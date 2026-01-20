//
//  WeatherModels.swift
//  Glasscast
//
//  Created by vishwas on 1/19/26.
//

import Foundation
import SwiftUI

struct WeatherResponse: Codable {
    let name: String
    let main: MainWeather
    let weather: [WeatherCondition]
    let wind: Wind
}

struct MainWeather: Codable {
    let temp: Double
    let temp_min: Double
    let temp_max: Double
    let humidity: Int
    
    enum CodingKeys: String, CodingKey {
        case temp, temp_min = "temp_min", temp_max = "temp_max", humidity
    }
}

struct WeatherCondition: Codable {
    let main: String
    let description: String
    let icon: String
}

struct Wind: Codable {
    let speed: Double
}

struct ForecastResponse: Codable {
    let list: [ForecastItem]
}

struct ForecastItem: Codable {
    let dt: TimeInterval
    let main: MainWeather
    let weather: [WeatherCondition]
    let dt_txt: String
}

struct GeoLocation: Codable, Identifiable {
    let name: String
    let lat: Double
    let lon: Double
    let country: String
    let state: String?
    
    var id: String { "\(name)-\(lat)-\(lon)" }
}

struct ForecastDay: Identifiable {
    let id = UUID()
    let day: String
    let icon: String
    let temp: Int
    let color: Color
}
