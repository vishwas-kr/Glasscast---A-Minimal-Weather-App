//
//  FavoritesViewModel.swift
//  Glasscast
//
//  Created by vishwas on 1/19/26.
//

import Foundation
import Combine
import CoreLocation

@MainActor
final class FavoritesViewModel: ObservableObject {
    @Published var favorites: [CityResult] = []
    @Published var isLoading = false
    
    private let favoritesService = FavoritesService.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        favoritesService.$favorites
            .receive(on: RunLoop.main)
            .sink { [weak self] favs in
                self?.favorites = favs
            }
            .store(in: &cancellables)
    }
    
    func loadFavorites() {
        isLoading = true
        Task {
            await favoritesService.load()
            isLoading = false
        }
    }
    
    func toggle(_ city: CityResult) {
        favoritesService.toggle(city)
    }
}