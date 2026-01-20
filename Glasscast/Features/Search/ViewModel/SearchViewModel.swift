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
    @Published var recentCities: [RecentSearchItem] = []
    @Published var results: [CityResult] = []
    @Published var isLoading: Bool = false
    
    private let weatherService = WeatherService()
    private let favoritesService = FavoritesService.shared
    private var searchTask: Task<Void, Never>?
    private var cancellables = Set<AnyCancellable>()
    private let recentCitiesKey = "recent_cities"
    
    init() {
        loadRecents()
        favoritesService.$favorites
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.updateFavoritesState()
            }
            .store(in: &cancellables)
    }
    
    func search() {
        searchTask?.cancel()
        guard !query.isEmpty else {
            results = []
            isLoading = false
            return
        }
        
        searchTask = Task {
            try? await Task.sleep(nanoseconds: 500_000_000)
            if Task.isCancelled { return }
            
            isLoading = true
            
            do {
                let locations = try await weatherService.searchLocations(query: query)
                self.results = locations.map { loc in
                    let city = CityResult(name: loc.name, country: loc.country, icon: "mappin.and.ellipse", location: CLLocation(latitude: loc.lat, longitude: loc.lon))
                    var finalCity = city
                    finalCity.isFavorite = self.favoritesService.isFavorite(city)
                   
                    return finalCity
                }
                isLoading = false
            } catch {
                print("Search error: \(error)")
                isLoading = false
            }
        }
    }
    
    func addRecent(_ city: CityResult) {
        let newItem = RecentSearchItem(
            name: city.name,
            country: city.country,
            lat: city.location.coordinate.latitude,
            lon: city.location.coordinate.longitude
        )
        
        recentCities.removeAll { $0.name == newItem.name && $0.country == newItem.country }
        recentCities.insert(newItem, at: 0)
        
        if recentCities.count > 3 {
            recentCities = Array(recentCities.prefix(3))
        }
        saveRecents()
    }
    
    private func loadRecents() {
        if let data = UserDefaults.standard.data(forKey: recentCitiesKey),
           let decoded = try? JSONDecoder().decode([RecentSearchItem].self, from: data) {
            recentCities = decoded
        }
    }
    
    private func saveRecents() {
        if let encoded = try? JSONEncoder().encode(recentCities) {
            UserDefaults.standard.set(encoded, forKey: recentCitiesKey)
        }
    }
    
    func toggleFavorite(_ city: CityResult) {
        favoritesService.toggle(city)
    }
    
    private func updateFavoritesState() {
        for index in results.indices {
            let city = results[index]
            results[index].isFavorite = favoritesService.isFavorite(city)
        }
    }
}
