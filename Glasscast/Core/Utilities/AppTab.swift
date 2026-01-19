//
//  AppTab.swift
//  Glasscast
//
//  Created by vishwas on 1/19/26.
//

enum AppTab: CaseIterable {
    case home
    case search
    case settings

    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .search: return "map"
        case .settings: return "gearshape"
        }
    }
}
