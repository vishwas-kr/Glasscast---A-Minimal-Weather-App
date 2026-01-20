//
//  ThemeManager.swift
//  Glasscast
//
//  Created by vishwas on 1/20/26.
//

import SwiftUI

struct ThemeManager {
    static func theme(for scheme: ColorScheme) -> AppTheme {
        scheme == .dark ? .dark : .light
    }
}
