//
//  AuthViewModel.swift
//  Glasscast
//
//  Created by vishwas on 1/18/26.
//

import Combine
import SwiftUI

@MainActor
final class AuthViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    @Published var isPasswordVisible = false
    @Published var isLoading = false
    @Published var mode: AuthMode = .signIn
    
    func toggleMode() {
        withAnimation(.smooth) {
            mode = mode == .signIn ? .signUp : .signIn
        }
    }
    
    func submit(session: SessionManager) {
        isLoading = true
        
        Task {
            try? await Task.sleep(nanoseconds: 800_000_000)
            isLoading = false
            session.signInSuccess()
        }
    }
}

