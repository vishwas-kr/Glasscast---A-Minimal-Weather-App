//
//  FavoritesService.swift
//  Glasscast
//
//  Created by vishwas on 1/19/26.
//

import Foundation
import Combine
import Supabase
import CoreLocation

final class FavoritesService: ObservableObject {
    static let shared = FavoritesService()
    
    @Published var favorites: [CityResult] = []
    private let client = SupabaseManager.client
    
    private init() {
        Task {
            await load()
        }
    }
    
    func toggle(_ city: CityResult) {
        Task {
            if isFavorite(city) {
                await remove(city)
            } else {
                await add(city)
            }
        }
    }
    
    func isFavorite(_ city: CityResult) -> Bool {
        favorites.contains(where: { $0.location.distance(from: city.location) < 2000 })
    }
    
    func load() async {
        guard let userId = client.auth.currentUser?.id else { return }
        
        do {
            let response: [FavoriteCityDTO] = try await client
                .from("favorite_cities")
                .select()
                .eq("user_id", value: userId)
                .execute()
                .value
            
            await MainActor.run {
                self.favorites = response.map { dto in
                    CityResult(
                        name: dto.city_name,
                        country: "", // Country is not persisted in the requested schema
                        icon: "mappin.and.ellipse",
                        location: CLLocation(latitude: dto.lat, longitude: dto.lon),
                        isFavorite: true
                    )
                }
            }
        } catch {
            print("Error loading favorites: \(error)")
        }
    }
    
    private func add(_ city: CityResult) async {
        guard let userId = client.auth.currentUser?.id else { return }
        
        await MainActor.run {
            var newCity = city
            newCity.isFavorite = true
            if !isFavorite(newCity) {
                favorites.append(newCity)
            }
        }
        
        let dto = FavoriteCityInsertDTO(
            user_id: userId,
            city_name: city.name,
            lat: city.location.coordinate.latitude,
            lon: city.location.coordinate.longitude
        )
        
        do {
            try await client
                .from("favorite_cities")
                .insert(dto)
                .execute()
        } catch {
            print("Error adding favorite: \(error)")
            await MainActor.run {
                if let index = favorites.firstIndex(where: { $0.location.distance(from: city.location) < 2000 }) {
                    favorites.remove(at: index)
                }
            }
        }
    }
    
    private func remove(_ city: CityResult) async {
        guard let userId = client.auth.currentUser?.id else { return }
        
        let match = favorites.first { $0.location.distance(from: city.location) < 2000 }
        guard let targetCity = match else { return }
        
        await MainActor.run {
            if let index = favorites.firstIndex(where: { $0.id == targetCity.id }) {
                favorites.remove(at: index)
            }
        }
        
        do {
            try await client
                .from("favorite_cities")
                .delete()
                .eq("user_id", value: userId)
                .eq("lat", value: targetCity.location.coordinate.latitude)
                .eq("lon", value: targetCity.location.coordinate.longitude)
                .execute()
        } catch {
            print("Error removing favorite: \(error)")
            await MainActor.run {
                var newCity = targetCity
                newCity.isFavorite = true
                favorites.append(newCity)
            }
        }
    }
}
