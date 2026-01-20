//
//  WeatherService.swift
//  Glasscast
//
//  Created by vishwas on 1/19/26.
//

import Foundation
import CoreLocation

protocol WeatherServicing {
    func fetchWeather(for location: CLLocation) async throws -> WeatherResponse
    func fetchForecast(for location: CLLocation) async throws -> [ForecastItem]
    func searchLocations(query: String) async throws -> [GeoLocation]
}

final class WeatherService: WeatherServicing {
    private let apiKey = AppEnvironment.openWeatherAPIKey
    private let baseURL = "https://api.openweathermap.org/data/2.5"
    
    func fetchWeather(for location: CLLocation) async throws -> WeatherResponse {
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        let url = "\(baseURL)/weather"

        var components = URLComponents(string: url)
        components?.queryItems = [
            URLQueryItem(name: "lat", value: "\(lat)"),
            URLQueryItem(name: "lon", value: "\(lon)"),
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: "metric")
        ]
        
        guard let url = components?.url else {
            throw URLError(.badURL)
        }
        print("Weather API: \(url)")
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            if let errorJson = String(data: data, encoding: .utf8) {
                print("Weather API Error: \(errorJson)")
            }
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(WeatherResponse.self, from: data)
    }
    
    func fetchForecast(for location: CLLocation) async throws -> [ForecastItem] {
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        let forecastURL = "\(baseURL)/forecast"

        var components = URLComponents(string: forecastURL)
        components?.queryItems = [
            URLQueryItem(name: "lat", value: "\(lat)"),
            URLQueryItem(name: "lon", value: "\(lon)"),
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: "metric")
        ]
        
        guard let url = components?.url else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(ForecastResponse.self, from: data).list
    }
    
    func searchLocations(query: String) async throws -> [GeoLocation] {
        let searchURL = "https://api.openweathermap.org/geo/1.0/direct"
        var components = URLComponents(string: searchURL)
        components?.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "limit", value: "5"),
            URLQueryItem(name: "appid", value: apiKey)
        ]
        
        guard let url = components?.url else { throw URLError(.badURL) }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode([GeoLocation].self, from: data)
    }
}
