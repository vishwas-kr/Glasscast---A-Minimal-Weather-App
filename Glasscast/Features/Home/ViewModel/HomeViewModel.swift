//
//  HomeViewModel.swift
//  Glasscast
//
//  Created by vishwas on 1/19/26.
//

import Combine

import SwiftUI
import CoreLocation

struct ForecastDay: Identifiable {
    let id = UUID()
    let day: String
    let icon: String
    let temp: Int
    let color: Color
}

@MainActor
final class HomeViewModel: ObservableObject {

    private let locationManager = LocationManager.shared
    private let weatherService = WeatherService()
    
    @Published var city = "Locating..."
    @Published var errorMessage: String?
    
    @Published var temperature = 0
    @Published var condition = "--"
    @Published var conditionIcon = "cloud"
    @Published var high = 0
    @Published var low = 0

    @Published var wind = 0
    @Published var humidity = 0

    let forecast: [ForecastDay] = [
        .init(day: "Mon", icon: "cloud.fill", temp: 22, color: .blue),
        .init(day: "Tue", icon: "cloud.sun.fill", temp: 21, color: .yellow),
        .init(day: "Wed", icon: "cloud.rain.fill", temp: 19, color: .gray),
        .init(day: "Thu", icon: "sun.max.fill", temp: 23, color: .yellow)
    ]
    
    func requestLocation() {
        Task {
            errorMessage = nil
            do {
                let location = try await locationManager.getCurrentLocation()
                print("Location fetched: \(location.coordinate)")
                await fetchWeather(for: location)
            } catch {
                print("Location Error: \(error)")
                errorMessage = "Unable to get location."
            }
        }
    }
    
    func fetchWeather(for location: CLLocation) async {
        self.city = "Fetching Weather..."
        
        do {
            let weather = try await weatherService.fetchWeather(for: location)
            
            self.city = weather.name
            self.temperature = Int(weather.main.temp)
            self.condition = weather.weather.first?.main ?? "Unknown"
            self.conditionIcon = mapIcon(weather.weather.first?.icon ?? "")
            self.high = Int(weather.main.temp_max)
            self.low = Int(weather.main.temp_min)
            self.humidity = weather.main.humidity
            self.wind = Int(weather.wind.speed * 3.6) // Convert m/s to km/h
        } catch {
            print("Weather API Error: \(error)")
            self.city = "--"
            self.errorMessage = "Unable to load weather data."
        }
    }
    
    private func mapIcon(_ code: String) -> String {
        switch code {
        case "01d", "01n": return "sun.max.fill"
        case "02d", "02n": return "cloud.sun.fill"
        case "03d", "03n", "04d", "04n": return "cloud.fill"
        case "09d", "09n": return "cloud.drizzle.fill"
        case "10d", "10n": return "cloud.rain.fill"
        case "11d", "11n": return "cloud.bolt.fill"
        case "13d", "13n": return "snowflake"
        case "50d", "50n": return "cloud.fog.fill"
        default: return "cloud.fill"
        }
    }
}
