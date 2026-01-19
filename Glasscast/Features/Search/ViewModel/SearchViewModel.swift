//
//  SearchViewModel.swift
//  Glasscast
//
//  Created by vishwas on 1/19/26.
//

import Combine

@MainActor
final class SearchViewModel: ObservableObject {

    @Published var query: String = ""
    @Published var recentCities: [RecentCity] = [
        .init(name: "Paris"),
        .init(name: "Berlin"),
        .init(name: "Sydney")
    ]

    @Published var results: [CityResult] = [
        .init(name: "London", country: "UNITED KINGDOM", icon: "cloud.fill"),
        .init(name: "Tokyo", country: "JAPAN", icon: "sun.max.fill", isFavorite: true),
        .init(name: "New York", country: "UNITED STATES", icon: "cloud.rain.fill"),
        .init(name: "Singapore", country: "SINGAPORE", icon: "cloud.bolt.fill")
    ]

    func toggleFavorite(_ city: CityResult) {
        guard let index = results.firstIndex(where: { $0.id == city.id }) else { return }
        results[index].isFavorite.toggle()
    }
}
