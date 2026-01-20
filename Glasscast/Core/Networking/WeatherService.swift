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
}

final class WeatherService: WeatherServicing {
    private let apiKey = Environment.openWeatherAPIKey
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"
    
    func fetchWeather(for location: CLLocation) async throws -> WeatherResponse {
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude

        var components = URLComponents(string: baseURL)
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
}
