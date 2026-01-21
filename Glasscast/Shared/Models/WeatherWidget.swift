//
//  WeatherWidget.swift
//  Glasscast
//
//  Created by vishwas on 1/21/26.
//

import Foundation

// This struct needs to be available to both the main app and the widget extension.
struct WeatherWidget: Codable {
    let temperature: Double
    let city: String
    let conditionSymbol: String
    let updatedAt: Date

    static var preview: WeatherWidget {
        WeatherWidget(temperature: 0, city: "---", conditionSymbol: "---", updatedAt: Date())
    }
}
