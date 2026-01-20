//
//  AppTheme.swift
//  Glasscast
//
//  Created by vishwas on 1/20/26.
//

import SwiftUI

extension AppTheme {
    
    static let light = AppTheme(
        background: LinearGradient(
            colors: [
                Color(red: 0.93, green: 0.95, blue: 0.97),
                Color(red: 0.78, green: 0.85, blue: 0.9)
            ],
            startPoint: .top,
            endPoint: .bottom
        ),
        cardMaterial: .ultraThickMaterial,
        primaryText: .primary,
        secondaryText: .secondary,
        accent: .blue
    )
    
    static let dark = AppTheme(
        background: LinearGradient(
            colors: [
                Color(red: 0.08, green: 0.11, blue: 0.20),
                Color(red: 0.04, green: 0.06, blue: 0.12)
            ],
            startPoint: .top,
            endPoint: .bottom
        ),
        cardMaterial: .ultraThinMaterial,
        primaryText: .white,
        secondaryText: .white.opacity(0.7),
        accent: Color(red: 0.35, green: 0.75, blue: 1.0)
    )
}
