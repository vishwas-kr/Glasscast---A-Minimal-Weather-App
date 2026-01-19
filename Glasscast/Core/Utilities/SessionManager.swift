//
//  SessionManager.swift
//  Glasscast
//
//  Created by vishwas on 1/19/26.
//

import Combine
import SwiftUI

@MainActor
final class SessionManager: ObservableObject {
    @Published var isAuthenticated = false

    func signInSuccess() {
        withAnimation(.smooth) {
            isAuthenticated = true
        }
    }

    func signOut() {
        withAnimation(.smooth) {
            isAuthenticated = false
        }
    }
}
