//
//  City.swift
//  Glasscast
//
//  Created by vishwas on 1/19/26.
//

import Foundation
import CoreLocation

struct CityResult: Identifiable, Codable, Equatable {
    var id: String { "\(name)-\(lat)-\(lon)" }
    let name: String
    let country: String
    let icon: String
    let lat: Double
    let lon: Double
    var isFavorite: Bool = false
    
    var location: CLLocation {
        CLLocation(latitude: lat, longitude: lon)
    }
    
    init(name: String, country: String, icon: String, location: CLLocation, isFavorite: Bool = false) {
        self.name = name
        self.country = country
        self.icon = icon
        self.lat = location.coordinate.latitude
        self.lon = location.coordinate.longitude
        self.isFavorite = isFavorite
    }
}

struct RecentSearchItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let country: String
    let lat: Double
    let lon: Double
}
