//
//  SettingsViewModel.swift
//  Glasscast
//
//  Created by vishwas on 1/19/26.
//

import Combine

@MainActor
final class SettingsViewModel: ObservableObject {

    @Published var temperatureUnit: TemperatureUnit = .celsius
    @Published var windSpeedUnit: WindSpeedUnit = .kmh
    @Published var severeAlertsEnabled = true

    let userName = "Alex Rivera"
    let email = "alex@glasscast.com"

    func toggleTemperature() {
        temperatureUnit.toggle()
    }

    func toggleWindSpeed() {
        windSpeedUnit.toggle()
    }

    func signOut() {
        // Hook into SessionManager / Supabase later
    }
}

enum TemperatureUnit {
    case celsius, fahrenheit

    mutating func toggle() {
        self = self == .celsius ? .fahrenheit : .celsius
    }
}

enum WindSpeedUnit {
    case kmh, mph

    mutating func toggle() {
        self = self == .kmh ? .mph : .kmh
    }
}
