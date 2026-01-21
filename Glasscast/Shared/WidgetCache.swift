//
//  WidgetCache.swift
//  Glasscast
//
//  Created by vishwas on 1/21/26.
//
import SwiftUI

final class WidgetCache {

    static let shared = WidgetCache()

    private let suite = UserDefaults(
        suiteName: "group.com.vishwas.glasscast"
    )

    func save(_ weather: WeatherWidget) {
        guard let data = try? JSONEncoder().encode(weather) else { return }
        suite?.set(data, forKey: "widget_weather")
    }

    func load() -> WeatherWidget? {
        guard
            let data = suite?.data(forKey: "widget_weather"),
            let weather = try? JSONDecoder().decode(
                WeatherWidget.self,
                from: data
            )
        else { return nil }

        return weather
    }
}
