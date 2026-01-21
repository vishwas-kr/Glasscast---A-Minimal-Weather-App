//
//  WeatherProvider.swift
//  Glasscast
//
//  Created by vishwas on 1/21/26.
//

import WidgetKit

struct Provider: TimelineProvider {


    func placeholder(in context: Context) -> Entry {
        Entry(date: Date(), weather: .preview)
    }

    func getSnapshot(
        in context: Context,
        completion: @escaping (Entry) -> Void
    ) {
        // In the widget gallery, show the preview data immediately.
        // For a real snapshot, load the actual cached data.
        let entry = context.isPreview ? Entry(date: Date(), weather: .preview) : loadEntry()
        completion(entry)
    }

    func getTimeline(
        in context: Context,
        completion: @escaping (Timeline<Entry>) -> Void
    ) {
        let entry = loadEntry()
        let nextRefresh = Calendar.current
            .date(byAdding: .minute, value: 30, to: Date())! // Refresh more frequently

        completion(
            Timeline(
                entries: [entry],
                policy: .after(nextRefresh)
            )
        )
    }

    private func loadEntry() -> Entry {
        let cached = WidgetCache.shared.load()
        // If `cached` is nil, it means the widget could not read the data
        // from the App Group. This usually points to a configuration issue in Xcode.
        return Entry(
            date: Date(),
            weather: cached ?? .preview
        )
    }
}
