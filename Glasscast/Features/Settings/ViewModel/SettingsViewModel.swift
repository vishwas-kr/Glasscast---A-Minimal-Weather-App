//
//  SettingsViewModel.swift
//  Glasscast
//
//  Created by vishwas on 1/19/26.
//

import Combine
import SwiftUI
import Supabase

@MainActor
final class SettingsViewModel: ObservableObject {

    @Published var temperatureUnit: TemperatureUnit = .celsius {
        didSet {
            UserDefaults.standard.set(temperatureUnit.rawValue, forKey: "temperatureUnit")
        }
    }
    @Published var windSpeedUnit: WindSpeedUnit = .kmh {
        didSet {
            UserDefaults.standard.set(windSpeedUnit.rawValue, forKey: "windSpeedUnit")
        }
    }
    @Published var severeAlertsEnabled = true

    @Published var userName = "Guest"
    @Published var email = ""
    
    private let client = SupabaseManager.client
    
    init() {
        if let tempStr = UserDefaults.standard.string(forKey: "temperatureUnit"),
           let temp = TemperatureUnit(rawValue: tempStr) {
            self.temperatureUnit = temp
        }
        
        if let windStr = UserDefaults.standard.string(forKey: "windSpeedUnit"),
           let wind = WindSpeedUnit(rawValue: windStr) {
            self.windSpeedUnit = wind
        }
        
        fetchAccount()
    }
    
    func fetchAccount() {
        guard let user = client.auth.currentUser else { return }
        self.email = user.email ?? ""
        if let namePart = self.email.split(separator: "@").first {
            self.userName = String(namePart).capitalized
        }
    }

    func toggleTemperature() {
        temperatureUnit.toggle()
    }

    func toggleWindSpeed() {
        windSpeedUnit.toggle()
    }

    func signOut() {
        Task {
            try? await AuthService.shared.signOut()
        }
    }
}

enum TemperatureUnit: String {
    case celsius, fahrenheit

    mutating func toggle() {
        self = self == .celsius ? .fahrenheit : .celsius
    }
}

enum WindSpeedUnit: String {
    case kmh, mph

    mutating func toggle() {
        self = self == .kmh ? .mph : .kmh
    }
}
