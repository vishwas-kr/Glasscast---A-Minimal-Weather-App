//
//  SearchView.swift
//  Glasscast
//
//  Created by vishwas on 1/19/26.
//
import SwiftUI
import CoreLocation

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @Environment(\.appTheme) var theme
    var onCitySelected: ((CLLocation) -> Void)?
    
    var body: some View {
        ZStack {
            theme.background
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
                .foregroundStyle(theme.primaryText)
        }
    }
    
    var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(theme.secondaryText)
            
            TextField("Search for a city...", text: $viewModel.query)
                .textInputAutocapitalization(.words)
                .onChange(of: viewModel.query) { _ in
                    viewModel.search()
                }
        }
        .padding()
        .background(theme.cardMaterial, in: Capsule())
    }
    var recentSearches: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("RECENT SEARCHES")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(theme.secondaryText)
            
            if viewModel.recentCities.isEmpty {
                Text("No Result")
                    .foregroundStyle(theme.secondaryText)
            } else {
                HStack(spacing: 12) {
                    ForEach(viewModel.recentCities) { city in
                        Text(city.name)
                            .foregroundStyle(theme.primaryText)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(theme.cardMaterial, in: Capsule())
                    }
                }
            }
        }
    }
    var results: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("RESULTS")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(theme.secondaryText)
            
            if viewModel.isLoading {
                ProgressView()
                    .tint(theme.secondaryText)
                    .frame(maxWidth: .infinity, alignment: .center)
            } else if viewModel.results.isEmpty {
                Text("No results found")
                    .foregroundStyle(theme.secondaryText)
            } else {
                ForEach(viewModel.results) { city in
                    resultRow(city)
                }
            }
        }
    }
    func resultRow(_ city: CityResult) -> some View {
        HStack(spacing: 16) {
            Image(systemName: city.icon)
                .frame(width: 44, height: 44)
                .foregroundStyle(theme.primaryText)
                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(city.name)
                    .font(.headline)
                    .foregroundStyle(theme.primaryText)
                
                Text(city.country)
                    .font(.caption)
                    .foregroundStyle(theme.secondaryText)
            }
            
            Spacer()
            
            Button {
                viewModel.toggleFavorite(city)
            } label: {
                Image(systemName: city.isFavorite ? "heart.fill" : "heart")
                    .foregroundStyle(city.isFavorite ? theme.accent : theme.secondaryText)
            }
        }
        .padding()
        .background(theme.cardMaterial, in: RoundedRectangle(cornerRadius: 20))
        .onTapGesture {
            viewModel.addRecent(city)
            onCitySelected?(city.location)
        }
    }
}
