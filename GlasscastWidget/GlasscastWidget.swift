//
//  GlasscastWidget.swift
//  GlasscastWidget
//
//  Created by vishwas on 1/21/26.
//

import WidgetKit
import SwiftUI

struct Entry: TimelineEntry {
    let date: Date
    let weather: WeatherWidget
}

struct GlasscastWidgetView: View {
    let entry: Entry

    var body: some View {
        VStack(spacing: 8) {
            Text(entry.weather.city)
                .font(.headline)

            Image(systemName: entry.weather.conditionSymbol)
                .font(.largeTitle)

            Text("\(Int(entry.weather.temperature))°C")
                .font(.system(size: 32, weight: .bold))

            Text("Updated \(entry.weather.updatedAt, style: .time)")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

struct GlasscastWidget: Widget {
    let kind: String = "GlasscastWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            GlasscastWidgetView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Glasscast Weather")
        .description("Displays the current weather for your location.")
        .supportedFamilies([.systemSmall])
    }
}

#Preview(as: .systemSmall) {
    GlasscastWidget()
} timeline: {
    Entry(date: .now, weather: .preview)
    Entry(date: .now, weather: WeatherWidget(
        temperature: 30, 
        city: "Miami",
        conditionSymbol: "sun.max.fill",
        updatedAt: .now
    ))
}
