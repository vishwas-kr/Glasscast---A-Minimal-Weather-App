//
//  City.swift
//  Glasscast
//
//  Created by vishwas on 1/19/26.
//

import Foundation

struct CityResult: Identifiable {
    let id = UUID()
    let name: String
    let country: String
    let icon: String
    var isFavorite: Bool = false
}

struct RecentCity: Identifiable {
    let id = UUID()
    let name: String
}
