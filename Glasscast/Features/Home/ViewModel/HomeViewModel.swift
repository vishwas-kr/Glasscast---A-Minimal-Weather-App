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

    @Published var forecast: [ForecastDay] = []
    
    func requestLocation() {
        Task {
            errorMessage = nil
            do {
                let location = try await locationManager.getCurrentLocation()
                print("Location fetched: \(location.coordinate)")
                await fetchWeather(for: location)
                await fetchForecast(for: location)
            } catch {
                print("Location Error: \(error)")
                errorMessage = "Unable to get location."
            }
        }
    }
    
    func loadWeather(for location: CLLocation) {
        Task {
            await fetchWeather(for: location)
            await fetchForecast(for: location)
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
    
    func fetchForecast(for location: CLLocation) async {
        do {
            let items = try await weatherService.fetchForecast(for: location)
            self.forecast = processForecast(items: items)
        } catch {
            print("Forecast API Error: \(error)")
        }
    }
    
    private func processForecast(items: [ForecastItem]) -> [ForecastDay] {
        let calendar = Calendar.current
        
        // Group items by day
        let grouped = Dictionary(grouping: items) { item -> String in
            let date = Date(timeIntervalSince1970: item.dt)
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter.string(from: date)
        }
        
        let sortedKeys = grouped.keys.sorted()
        
        return sortedKeys.compactMap { key -> ForecastDay? in
            guard let dayItems = grouped[key] else { return nil }
            
            // Find the item closest to 12:00 PM to represent the day
            let bestItem = dayItems.min(by: { a, b in
                let hourA = abs(calendar.component(.hour, from: Date(timeIntervalSince1970: a.dt)) - 12)
                let hourB = abs(calendar.component(.hour, from: Date(timeIntervalSince1970: b.dt)) - 12)
                return hourA < hourB
            })
            
            guard let item = bestItem else { return nil }
            
            let date = Date(timeIntervalSince1970: item.dt)
            let dayName = getDayName(date: date)
            let icon = mapIcon(item.weather.first?.icon ?? "")
            let temp = Int(item.main.temp)
            
            // Determine color based on weather
            let condition = item.weather.first?.main.lowercased() ?? ""
            let color: Color
            if condition.contains("rain") { color = .gray }
            else if condition.contains("clear") { color = .yellow }
            else if condition.contains("cloud") { color = .blue }
            else { color = .primary }
            
            return ForecastDay(day: dayName, icon: icon, temp: temp, color: color)
        }.prefix(5).map { $0 }
    }
    
    private func getDayName(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter.string(from: date)
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
