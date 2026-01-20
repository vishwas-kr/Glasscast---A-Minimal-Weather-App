//
//  AppTab.swift
//  Glasscast
//
//  Created by vishwas on 1/19/26.
//

enum AppTab: String, CaseIterable {
    case home
    case search
    case favorites
    case settings
    
    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .search: return "magnifyingglass"
        case .favorites: return "heart.fill"
        case .settings: return "gearshape.fill"
        }
    }
}
