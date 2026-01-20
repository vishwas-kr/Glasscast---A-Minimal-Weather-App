//
//  RootView.swift
//  Glasscast
//
//  Created by vishwas on 1/19/26.
//

import SwiftUI

struct RootView: View {
    @ObservedObject private var sessionManager = SessionManager.shared
    
    var body: some View {
        Group {
            if sessionManager.isAuthenticated {
                RootTabView()
                    .transition(.opacity)
            } else {
                AuthView()
                    .transition(.opacity)
            }
        }
        .environmentObject(sessionManager)
        .animation(.smooth, value: sessionManager.isAuthenticated)
    }
}