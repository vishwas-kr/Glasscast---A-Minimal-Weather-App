//
//  SessionManager.swift
//  Glasscast
//
//  Created by vishwas on 1/19/26.
//

import Combine
import SwiftUI
import Supabase

@MainActor
final class SessionManager: ObservableObject {
    static let shared = SessionManager()
    
    @Published var session: Session?
    @Published var isAuthenticated = false
    
    private let client = SupabaseManager.client
    
    init() {
        checkAppState()
    }
    
    private func checkAppState(){
        Task {
            do {
                let currentSession = try await client.auth.session
                self.session = currentSession
                self.isAuthenticated = true
            } catch {}
            
            for await state in client.auth.authStateChanges {
                self.session = state.session
                withAnimation(.smooth) {
                    self.isAuthenticated = (state.session != nil)
                }
            }
        }
    }
}
