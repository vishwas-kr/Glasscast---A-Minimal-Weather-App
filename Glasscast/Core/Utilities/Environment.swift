//
//  Environment.swift
//  Glasscast
//
//  Created by vishwas on 1/19/26.
//

import Foundation

enum AppEnvironment {

    static var supabaseURL: URL {
        print("Info.plist SUPABASE_URL:", Bundle.main.object(forInfoDictionaryKey: "SUPABASE_URL") ?? "nil")

        guard
            let urlString = Bundle.main.object(
                forInfoDictionaryKey: "SUPABASE_URL"
            ) as? String,
            let url = URL(string: urlString)
        else {
            fatalError("❌ SUPABASE_URL not set")
        }
        return url
    }

    static var supabaseAnonKey: String {
        guard
            let key = Bundle.main.object(
                forInfoDictionaryKey: "SUPABASE_ANON_KEY"
            ) as? String
        else {
            fatalError("❌ SUPABASE_ANON_KEY not set")
        }
        return key
    }
    
    static var openWeatherAPIKey: String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "WEATHER_API_KEY") as? String else {
            fatalError("❌ OPENWEATHER_API_KEY not found in Info.plist")
        }
        return key
    }
}
