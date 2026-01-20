//
//  MetricCard.swift
//  Glasscast
//
//  Created by vishwas on 1/20/26.
//
import SwiftUI

struct MetricCard: View {
    let icon: String
    let title: String
    let value: String
    @Environment(\.appTheme) var theme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(title, systemImage: icon)
                .foregroundStyle(theme.secondaryText)
            
            Text(value)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(theme.primaryText)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(theme.cardMaterial, in: RoundedRectangle(cornerRadius: 24))
    }
}
