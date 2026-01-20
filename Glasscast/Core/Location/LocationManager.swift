//
//  LocationManager.swift
//  Glasscast
//
//  Created by vishwas on 1/19/26.
//

import CoreLocation
import Combine

@MainActor
final class LocationManager: NSObject, ObservableObject {
    static let shared = LocationManager()
    
    private let manager = CLLocationManager()
    
    @Published var location: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus
    @Published var errorMessage: String?
    
    private var locationContinuation: CheckedContinuation<CLLocation, Error>?

    override init() {
        self.authorizationStatus = manager.authorizationStatus
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        manager.distanceFilter = 1000
    }
    
    func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }
    
    func getCurrentLocation() async throws -> CLLocation {
        let status = manager.authorizationStatus
        
        if status == .denied || status == .restricted {
            throw LocationError.permissionDenied
        }
        
        if status == .notDetermined {
            manager.requestWhenInUseAuthorization()
        }

        return try await withCheckedThrowingContinuation { continuation in
            if let existingContinuation = locationContinuation {
                existingContinuation.resume(throwing: LocationError.cancelled)
            }
            
            self.locationContinuation = continuation
            manager.requestLocation()
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.authorizationStatus = manager.authorizationStatus
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
        
        if let continuation = locationContinuation {
            continuation.resume(returning: location)
            self.locationContinuation = nil
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let clError = error as? CLError, clError.code == .locationUnknown {
            return
        }
        
        let finalError: Error
        if let clError = error as? CLError, clError.code == .denied {
            finalError = LocationError.permissionDenied
        } else {
            finalError = error
        }
        
        self.errorMessage = finalError.localizedDescription
        
        if let continuation = locationContinuation {
            continuation.resume(throwing: finalError)
            self.locationContinuation = nil
        }
    }
}

enum LocationError: LocalizedError {
    case permissionDenied
    case cancelled
    
    var errorDescription: String? {
        switch self {
        case .permissionDenied:
            return "Location access is denied. Please enable it in Settings."
        case .cancelled:
            return "Location request was cancelled."
        }
    }
}
