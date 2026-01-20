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
    private let favoritesService = FavoritesService.shared
    private var cancellables = Set<AnyCancellable>()
    
    @Published var city = "Locating..."
    @Published var errorMessage: String?
    
    @Published var temperature = 0
    @Published var condition = "--"
    @Published var conditionIcon = "cloud"
    @Published var high = 0
    @Published var low = 0

    @Published var wind = 0
    @Published var windUnit = "km/h"
    @Published var humidity = 0
    @Published var isLoading = false
    @Published var isFavorite = false

    @Published var forecast: [ForecastDay] = []
    
    // Store raw data to allow unit switching without refetching
    private var lastWeather: WeatherResponse?
    private var lastForecastItems: [ForecastItem]?
    private var currentLocation: CLLocation?
    
    init() {
        // Listen for unit changes
        NotificationCenter.default.addObserver(self, selector: #selector(handleUnitChange), name: UserDefaults.didChangeNotification, object: nil)
        
        favoritesService.$favorites
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.checkIfFavorite()
            }
            .store(in: &cancellables)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func handleUnitChange() {
        Task { @MainActor in
            if let weather = lastWeather {
                updateWeatherUI(with: weather)
            }
            if let items = lastForecastItems {
                self.forecast = processForecast(items: items)
            }
        }
    }
    
    func requestLocation() {
        Task {
            isLoading = true
            errorMessage = nil
            do {
                let location = try await locationManager.getCurrentLocation()
                self.currentLocation = location
                print("Location fetched: \(location.coordinate)")
                await fetchWeather(for: location)
                await fetchForecast(for: location)
            } catch {
                print("Location Error: \(error)")
                errorMessage = "Unable to get location."
            }
            isLoading = false
        }
    }
    
    func loadWeather(for location: CLLocation) {
        self.currentLocation = location
        Task {
            isLoading = true
            await fetchWeather(for: location)
            await fetchForecast(for: location)
            isLoading = false
        }
    }
    
    func refresh() async {
        if let location = currentLocation {
            await fetchWeather(for: location, isRefreshing: true)
            await fetchForecast(for: location)
        } else {
            do {
                let location = try await locationManager.getCurrentLocation()
                self.currentLocation = location
                await fetchWeather(for: location, isRefreshing: true)
                await fetchForecast(for: location)
            } catch {
                errorMessage = "Unable to refresh location."
            }
        }
    }
    
    func fetchWeather(for location: CLLocation, isRefreshing: Bool = false) async {
        if !isRefreshing {
            self.city = "Fetching..."
        }
        
        do {
            let weather = try await weatherService.fetchWeather(for: location)
            self.lastWeather = weather
            updateWeatherUI(with: weather)
        } catch {
            print("Weather API Error: \(error)")
            self.city = "--"
            self.errorMessage = "Unable to load weather data."
        }
    }
    
    private func updateWeatherUI(with weather: WeatherResponse) {
        self.city = weather.name
        
        checkIfFavorite()
        
        let isCelsius = (UserDefaults.standard.string(forKey: "temperatureUnit") ?? "celsius") == "celsius"
        let isKmh = (UserDefaults.standard.string(forKey: "windSpeedUnit") ?? "kmh") == "kmh"
        
        self.temperature = convertTemp(weather.main.temp, isCelsius: isCelsius)
        self.high = convertTemp(weather.main.temp_max, isCelsius: isCelsius)
        self.low = convertTemp(weather.main.temp_min, isCelsius: isCelsius)
        
        self.condition = weather.weather.first?.main ?? "Unknown"
        self.conditionIcon = mapIcon(weather.weather.first?.icon ?? "")
        self.humidity = weather.main.humidity
        
        let speedKmh = weather.wind.speed * 3.6
        self.wind = isKmh ? Int(speedKmh) : Int(speedKmh * 0.621371)
        self.windUnit = isKmh ? "km/h" : "mph"
    }
    
    func toggleFavorite() {
        guard let location = currentLocation, city != "Locating...", city != "Fetching...", city != "--" else { return }
        
        let cityResult = CityResult(
            name: city,
            country: "",
            icon: "mappin.and.ellipse",
            location: location
        )
        favoritesService.toggle(cityResult)
    }
    
    private func checkIfFavorite() {
        guard let location = currentLocation else {
            isFavorite = false
            return
        }
        let tempCity = CityResult(name: city, country: "", icon: "mappin.and.ellipse", location: location)
        isFavorite = favoritesService.isFavorite(tempCity)
    }
    
    private func convertTemp(_ celsius: Double, isCelsius: Bool) -> Int {
        return isCelsius ? Int(celsius) : Int(celsius * 9/5 + 32)
    }
    
    func fetchForecast(for location: CLLocation) async {
        do {
            let items = try await weatherService.fetchForecast(for: location)
            self.lastForecastItems = items
            self.forecast = processForecast(items: items)
        } catch {
            print("Forecast API Error: \(error)")
        }
    }
    
    private func processForecast(items: [ForecastItem]) -> [ForecastDay] {
        let isCelsius = (UserDefaults.standard.string(forKey: "temperatureUnit") ?? "celsius") == "celsius"
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
            let temp = convertTemp(item.main.temp, isCelsius: isCelsius)
            
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
