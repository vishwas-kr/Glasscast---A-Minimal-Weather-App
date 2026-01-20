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
    private var authContinuation: CheckedContinuation<CLAuthorizationStatus, Never>?

    override init() {
        self.authorizationStatus = manager.authorizationStatus
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        manager.distanceFilter = 1000
    }
    
    // MARK: - Permission Handling
    
    private func requestPermissionIfNeeded() async -> CLAuthorizationStatus {
        let status = manager.authorizationStatus
        
        if status != .notDetermined {
            return status
        }
        
        manager.requestWhenInUseAuthorization()
        
        return await withCheckedContinuation { continuation in
            self.authContinuation = continuation
        }
    }
    
    // MARK: - Location
    
    func getCurrentLocation() async throws -> CLLocation {
        let status = await requestPermissionIfNeeded()
        
        guard status == .authorizedWhenInUse || status == .authorizedAlways else {
            throw LocationError.permissionDenied
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            if let existing = locationContinuation {
                existing.resume(throwing: LocationError.cancelled)
            }
            
            self.locationContinuation = continuation
            manager.requestLocation()
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        
        if let continuation = authContinuation {
            continuation.resume(returning: authorizationStatus)
            authContinuation = nil
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
        
        locationContinuation?.resume(returning: location)
        locationContinuation = nil
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
        
        errorMessage = finalError.localizedDescription
        
        locationContinuation?.resume(throwing: finalError)
        locationContinuation = nil
    }
}

// MARK: - Errors

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
