//
//  GlasscastApp.swift
//  Glasscast
//
//  Created by vishwas on 1/18/26.
//

import SwiftUI

@main
struct GlasscastApp: App {
    @StateObject private var session = SessionManager()
    
    var body: some Scene {
        WindowGroup {
            Group {
                if session.isAuthenticated {
                    HomeView()
                } else {
                    AuthView()
                }
            }
            .environmentObject(session)
        }
    }
}
