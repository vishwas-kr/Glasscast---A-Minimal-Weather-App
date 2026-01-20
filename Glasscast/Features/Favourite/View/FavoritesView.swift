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
    var onSelect: (CLLocation) -> Void
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.93, green: 0.95, blue: 0.97), Color(red: 0.78, green: 0.85, blue: 0.9)],
                startPoint: .top, endPoint: .bottom
            ).ignoresSafeArea()
            
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
            Spacer()
        }
        .padding()
    }
    
    var emptyState: some View {
        VStack(spacing: 12) {
            Spacer()
            Image(systemName: "heart.slash")
                .font(.largeTitle)
                .foregroundStyle(.secondary)
            Text("No favorites yet")
                .foregroundStyle(.secondary)
            Spacer()
        }
    }
    
    var favoritesList: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(viewModel.favorites) { city in
                    HStack {
                        Text(city.name).font(.headline)
                        Spacer()
                        Button {
                            viewModel.toggle(city)
                        } label: {
                            Image(systemName: "heart.fill").foregroundStyle(.teal)
                        }
                    }
                    .padding()
                    .background(.ultraThickMaterial, in: RoundedRectangle(cornerRadius: 20))
                    .onTapGesture {
                        onSelect(city.location)
                    }
                }
            }
            .padding()
        }
    }
}
