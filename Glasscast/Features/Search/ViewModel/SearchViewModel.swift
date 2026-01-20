//
//  SearchViewModel.swift
//  Glasscast
//
//  Created by vishwas on 1/19/26.
//

import Combine
import SwiftUI
import CoreLocation

@MainActor
final class SearchViewModel: ObservableObject {

    @Published var query: String = ""
    @Published var recentCities: [RecentCity] = []
    @Published var results: [CityResult] = []
    
    private let weatherService = WeatherService()
    private var searchTask: Task<Void, Never>?

    func search() {
        searchTask?.cancel()
        guard !query.isEmpty else {
            results = []
            return
        }
        
        searchTask = Task {
            try? await Task.sleep(nanoseconds: 500_000_000) // 0.5s debounce
            
            do {
                let locations = try await weatherService.searchLocations(query: query)
                self.results = locations.map { loc in
                    CityResult(name: loc.name, country: loc.country, icon: "mappin.and.ellipse", location: CLLocation(latitude: loc.lat, longitude: loc.lon))
                }
                recentCities.append(RecentCity(name: query))
            } catch {
                print("Search error: \(error)")
            }
        }
    }

    func toggleFavorite(_ city: CityResult) {
        guard let index = results.firstIndex(where: { $0.id == city.id }) else { return }
        results[index].isFavorite.toggle()
    }
}
