//
//  Theme.swift
//  Glasscast
//
//  Created by vishwas on 1/20/26.
//

import SwiftUI

struct AppTheme {
    let background: LinearGradient
    let cardMaterial: Material
    let primaryText: Color
    let secondaryText: Color
    let accent: Color
}

enum AppAppearance: String, CaseIterable, Identifiable {
    case system
    case light
    case dark
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .system: return "System"
        case .light: return "Light"
        case .dark: return "Dark"
        }
    }
}

struct AppThemeKey: EnvironmentKey {
    static let defaultValue: AppTheme = .light
}

extension EnvironmentValues {
    var appTheme: AppTheme {
        get { self[AppThemeKey.self] }
        set { self[AppThemeKey.self] = newValue }
    }
}

struct ThemeModifier: ViewModifier {
    @AppStorage("appAppearance") private var appearance: AppAppearance = .system
    @Environment(\.colorScheme) var systemScheme
    
    func body(content: Content) -> some View {
        let selectedScheme: ColorScheme?
        switch appearance {
        case .light: selectedScheme = .light
        case .dark: selectedScheme = .dark
        case .system: selectedScheme = nil
        }
        
        return content
            .environment(\.appTheme, ThemeManager.theme(for: selectedScheme ?? systemScheme))
            .preferredColorScheme(selectedScheme)
    }
}
