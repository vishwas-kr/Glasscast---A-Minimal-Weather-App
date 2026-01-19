//
//  SupabaseManager.swift
//  Glasscast
//
//  Created by vishwas on 1/19/26.
//

import Supabase
import Foundation

enum SupabaseManager {
    static let client = SupabaseClient(
        supabaseURL: URL(string:"\(Environment.supabaseURL.absoluteString)")!,
        supabaseKey: Environment.supabaseAnonKey
    )
}
