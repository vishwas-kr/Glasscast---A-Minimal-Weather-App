//
//  HomeView.swift
//  Glasscast
//
//  Created by vishwas on 1/19/26.
//

import SwiftUI
import CoreLocation

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    @State private var showFavorites = false
    
    var body: some View {
        ZStack {
            background
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                header
                currentWeatherCard
                fiveDayForecast
                metricsRow
                Spacer()
            }
            .padding()
        }
        .alert("Error", isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { _ in viewModel.errorMessage = nil }
        )) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
        .sheet(isPresented: $showFavorites) {
            FavoritesView { location in
                viewModel.loadWeather(for: location)
            }
        }
    }
    var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(currentDateString)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Text(viewModel.city)
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            
            Spacer()
            Button {
                showFavorites = true
            } label: {
                Image(systemName: "heart.fill")
                    .font(.system(size: 22))
                    .foregroundStyle(.blue.opacity(0.8))
                    .padding()
                    .background(.clear, in: Circle())
                    
            }
            .glassEffect()
        }
    }
    
    var currentWeatherCard: some View {
        VStack(spacing: 16) {
            Text("\(viewModel.temperature)°")
                .font(.system(size: 96, weight: .bold))
            
            HStack(spacing: 8) {
                Image(systemName: viewModel.conditionIcon)
                    .foregroundStyle(.blue)
                
                Text(viewModel.condition)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(.ultraThickMaterial, in: Capsule())
            
            Text("H: \(viewModel.high)°   L: \(viewModel.low)°")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(32)
        .background(
            RoundedRectangle(cornerRadius: 36, style: .continuous)
                .fill(.ultraThinMaterial)
                .shadow(radius: 20)
        )
        .animation(.smooth, value: viewModel.temperature)
        .padding(.vertical)
    }
    
    var fiveDayForecast: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("5-DAY FORECAST")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
            }
            
            ScrollView(.horizontal,showsIndicators: false){
                HStack(spacing: 16) {
                    ForEach(viewModel.forecast) { day in
                        ForecastCard(day: day)
                    }
                }
            }
        }
    }
    
    var metricsRow: some View {
        HStack(spacing: 16) {
            MetricCard(
                icon: "wind",
                title: "Wind",
                value: "\(viewModel.wind) km/h"
            )
            
            MetricCard(
                icon: "drop.fill",
                title: "Humidity",
                value: "\(viewModel.humidity)%"
            )
        }
    }
}
#Preview {
    HomeView(viewModel: HomeViewModel())
}
struct MetricCard: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(title, systemImage: icon)
                .foregroundStyle(.secondary)
            
            Text(value)
                .font(.title3)
                .fontWeight(.semibold)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24))
    }
}

struct ForecastCard: View {
    let day: ForecastDay
    
    var body: some View {
        VStack(spacing: 12) {
            Text(day.day)
                .font(.subheadline)
            
            Image(systemName: day.icon)
                .foregroundStyle(day.color)
            
            Text("\(day.temp)°")
                .font(.headline)
        }
        .padding(22)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24))
    }
}


private extension HomeView {
    private var currentDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMM"
        return formatter.string(from: Date()).uppercased()
    }
    
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


struct FavoritesView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var favoritesService = FavoritesService.shared
    var onSelect: (CLLocation) -> Void
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [Color(red: 0.93, green: 0.95, blue: 0.97), Color(red: 0.78, green: 0.85, blue: 0.9)],
                    startPoint: .top, endPoint: .bottom
                ).ignoresSafeArea()
                
                if favoritesService.favorites.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "heart.slash")
                            .font(.largeTitle)
                            .foregroundStyle(.secondary)
                        Text("No favorites yet")
                            .foregroundStyle(.secondary)
                    }
                } else {
                    List {
                        ForEach(favoritesService.favorites) { city in
                            Button {
                                onSelect(city.location)
                                dismiss()
                            } label: {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(city.name).font(.headline)
                                        Text(city.country).font(.caption).foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                    Button {
                                        favoritesService.toggle(city)
                                    } label: {
                                        Image(systemName: "heart.fill").foregroundStyle(.teal)
                                    }
                                }
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("Favorites")
            .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Close") { dismiss() } } }
        }
    }
}
