//
//  HomeView.swift
//  Glasscast
//
//  Created by vishwas on 1/19/26.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
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
    }
    var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("MONDAY, 14 OCT")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Text(viewModel.city)
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            
            Spacer()
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
            
            HStack(spacing: 16) {
                ForEach(viewModel.forecast) { day in
                    ForecastCard(day: day)
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
    HomeView()
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
