//
//  View.swift
//  Glasscast
//
//  Created by vishwas on 1/20/26.
//
import SwiftUI

extension View {
    func withAppTheme() -> some View {
        modifier(ThemeModifier())
    }
}
