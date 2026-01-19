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
    
    private let authService: AuthServicing = AuthService()
    
    @Published var email = ""
    @Published var password = ""
    @Published var isPasswordVisible = false
    @Published var isLoading = false
    @Published var mode: AuthMode = .signIn
    @Published var errorMessage: String?
    
    func toggleMode() {
        withAnimation(.smooth) {
            mode = mode == .signIn ? .signUp : .signIn
            if !email.isEmpty || !password.isEmpty {
                email = ""
                password = ""
            }
        }
    }
    
    func submit(session: SessionManager) {
        isLoading = true
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter both email and password."
            return
        }
        errorMessage = nil
        Task {
            do {
                if mode == .signIn {
                    try await authService.signIn(email: email, password: password)
                } else {
                    try await authService.signUp(email: email, password: password)
                }
                session.signInSuccess()
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
}

