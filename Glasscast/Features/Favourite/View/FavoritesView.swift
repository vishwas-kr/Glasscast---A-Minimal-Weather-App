//
//  FavoritesView.swift
//  Glasscast
//
//  Created by vishwas on 1/19/26.
//

import SwiftUI
import CoreLocation

struct FavoritesView: View {
    @StateObject private var viewModel = FavoritesViewModel()
    @Environment(\.appTheme) var theme
    var onSelect: (CLLocation) -> Void
    
    var body: some View {
        ZStack {
            theme.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                header
                
                if viewModel.isLoading {
                    Spacer()
                    ProgressView()
                        .scaleEffect(1.5)
                    Spacer()
                } else if viewModel.favorites.isEmpty {
                    emptyState
                } else {
                    favoritesList
                }
            }
        }
        .onAppear {
            viewModel.loadFavorites()
        }
    }
    
    var header: some View {
        HStack {
            Text("Favourites")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundStyle(theme.primaryText)
            Spacer()
        }
        .padding()
    }
    
    var emptyState: some View {
        VStack(spacing: 12) {
            Spacer()
            Image(systemName: "heart.slash")
                .font(.largeTitle)
                .foregroundStyle(theme.secondaryText)
            Text("No favorites yet")
                .foregroundStyle(theme.secondaryText)
            Spacer()
        }
    }
    
    var favoritesList: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(viewModel.favorites) { city in
                    HStack {
                        Text(city.name)
                            .font(.headline)
                            .foregroundStyle(theme.primaryText)
                        Spacer()
                        Button {
                            viewModel.toggle(city)
                        } label: {
                            Image(systemName: "heart.fill").foregroundStyle(theme.accent)
                        }
                    }
                    .padding()
                    .background(theme.cardMaterial, in: RoundedRectangle(cornerRadius: 20))
                    .onTapGesture {
                        onSelect(city.location)
                    }
                }
            }
            .padding()
        }
    }
}
