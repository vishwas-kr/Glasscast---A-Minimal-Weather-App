//
//  ForecaseCard.swift
//  Glasscast
//
//  Created by vishwas on 1/20/26.
//
import SwiftUI

struct ForecastCard: View {
    let day: ForecastDay
    @Environment(\.appTheme) var theme
    
    var body: some View {
        VStack(spacing: 12) {
            Text(day.day)
                .font(.subheadline)
                .foregroundStyle(theme.primaryText)
            
            Image(systemName: day.icon)
                .foregroundStyle(day.color)
            
            Text("\(day.temp)°")
                .font(.headline)
                .foregroundStyle(theme.primaryText)
        }
        .padding(22)
        .background(theme.cardMaterial, in: RoundedRectangle(cornerRadius: 24))
    }
}
