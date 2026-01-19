//
//  HomeViewModel.swift
//  Glasscast
//
//  Created by vishwas on 1/19/26.
//

import Combine

import SwiftUI

struct ForecastDay: Identifiable {
    let id = UUID()
    let day: String
    let icon: String
    let temp: Int
    let color: Color
}

@MainActor
final class HomeViewModel: ObservableObject {

    let city = "San Francisco"
    let temperature = 22
    let condition = "Mostly Cloudy"
    let conditionIcon = "cloud.fill"
    let high = 24
    let low = 18

    let wind = 12
    let humidity = 48

    let forecast: [ForecastDay] = [
        .init(day: "Mon", icon: "cloud.fill", temp: 22, color: .blue),
        .init(day: "Tue", icon: "cloud.sun.fill", temp: 21, color: .yellow),
        .init(day: "Wed", icon: "cloud.rain.fill", temp: 19, color: .gray),
        .init(day: "Thu", icon: "sun.max.fill", temp: 23, color: .yellow)
    ]
}
