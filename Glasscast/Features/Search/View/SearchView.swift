//
//  SearchView.swift
//  Glasscast
//
//  Created by vishwas on 1/19/26.
//
import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            background
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading,spacing: 24) {
                    header
                    searchBar
                    recentSearches
                    results
                }
                .padding()
            }
        }
    }
    
    var header: some View {
        HStack {
            Text("Search City")
                .font(.title)
                .fontWeight(.semibold)
        }
    }
    
    var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)

            TextField("Search for a city...", text: $viewModel.query)
                .textInputAutocapitalization(.words)
        }
        .padding()
        .background(.ultraThickMaterial, in: Capsule())
    }
    var recentSearches: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("RECENT SEARCHES")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                ForEach(viewModel.recentCities) { city in
                    Text(city.name)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(.ultraThickMaterial, in: Capsule())
                }
            }
        }
    }
    var results: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("RESULTS")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)

            ForEach(viewModel.results) { city in
                resultRow(city)
            }
        }
    }
    func resultRow(_ city: CityResult) -> some View {
        HStack(spacing: 16) {
            Image(systemName: city.icon)
                .frame(width: 44, height: 44)
                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 4) {
                Text(city.name)
                    .font(.headline)

                Text(city.country)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Button {
                viewModel.toggleFavorite(city)
            } label: {
                Image(systemName: city.isFavorite ? "heart.fill" : "heart")
                    .foregroundStyle(city.isFavorite ? .teal : .secondary)
            }
        }
        .padding()
        .background(.ultraThickMaterial, in: RoundedRectangle(cornerRadius: 20))
    }
}

private extension SearchView {
    var background: some View {
        LinearGradient(
            colors: [
                Color(red: 0.93, green: 0.95, blue: 0.97),
                Color(red: 0.78, green: 0.85, blue: 0.9)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}
