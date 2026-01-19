//
//  AuthButton.swift
//  Glasscast
//
//  Created by vishwas on 1/18/26.
//

import Foundation

import SwiftUI
struct AuthButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(.white)
            .background(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [Color.blue.opacity(0.9), Color.cyan.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .shadow(color: .blue.opacity(0.4), radius: 20, y: 12)
            .animation(.spring(response: 0.35), value: configuration.isPressed)
    }
}
