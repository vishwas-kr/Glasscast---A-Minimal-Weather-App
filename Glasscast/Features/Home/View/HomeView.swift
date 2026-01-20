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
    @Environment(\.appTheme) private var theme

    var body: some View {
        ZStack {
            theme.background
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    header

                    if viewModel.isLoading {
                        ProgressView()
                            .scaleEffect(1.5)
                            .padding(.top, 60)
                    } else {
                        currentWeatherCard
                        fiveDayForecast
                        metricsRow
                    }
                }
                .padding()
            }
            .refreshable {
                await viewModel.refresh()
            }
        }
        .alert("Error", isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { _ in viewModel.errorMessage = nil }
        )) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
}

// MARK: - Header
private extension HomeView {

    var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(currentDateString)
                    .font(.caption)
                    .foregroundStyle(theme.secondaryText)

                Text(viewModel.city)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(theme.primaryText)
            }

            Spacer()

            Button {
                viewModel.toggleFavorite()
            } label: {
                Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                    .font(.system(size: 22))
                    .foregroundStyle(
                        viewModel.isFavorite ? theme.accent : theme.secondaryText
                    )
                    .padding()
                    .background(.clear, in: Circle())
            }
            .glassEffect()
        }
    }

    // MARK: - Current Weather
    var currentWeatherCard: some View {
        VStack(spacing: 16) {
            Text("\(viewModel.temperature)°")
                .font(.system(size: 96, weight: .bold))
                .foregroundStyle(theme.primaryText)

            HStack(spacing: 8) {
                Image(systemName: viewModel.conditionIcon)
                    .foregroundStyle(theme.accent)

                Text(viewModel.condition)
                    .foregroundStyle(theme.primaryText)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(theme.cardMaterial, in: Capsule())

            Text("H: \(viewModel.high)°   L: \(viewModel.low)°")
                .foregroundStyle(theme.secondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(32)
        .background(
            RoundedRectangle(cornerRadius: 36, style: .continuous)
                .fill(theme.cardMaterial)
                .shadow(radius: 20)
        )
        .animation(.smooth, value: viewModel.temperature)
        .padding(.vertical)
    }

    // MARK: - Forecast
    var fiveDayForecast: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("5-DAY FORECAST")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(theme.secondaryText)

                Spacer()
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.forecast) { day in
                        ForecastCard(day: day)
                    }
                }
            }
        }
    }

    // MARK: - Metrics
    var metricsRow: some View {
        HStack(spacing: 16) {
            MetricCard(
                icon: "wind",
                title: "Wind",
                value: "\(viewModel.wind) \(viewModel.windUnit)"
            )

            MetricCard(
                icon: "drop.fill",
                title: "Humidity",
                value: "\(viewModel.humidity)%"
            )
        }
    }

    var currentDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMM"
        return formatter.string(from: Date()).uppercased()
    }
}

// MARK: - Metric Card
struct MetricCard: View {
    let icon: String
    let title: String
    let value: String
    @Environment(\.appTheme) var theme

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(title, systemImage: icon)
                .foregroundStyle(theme.secondaryText)

            Text(value)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(theme.primaryText)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(theme.cardMaterial, in: RoundedRectangle(cornerRadius: 24))
    }
}

// MARK: - Forecast Card
struct ForecastCard: View {
    let day: ForecastDay
    @Environment(\.appTheme) var theme

    var body: some View {
        VStack(spacing: 12) {
            Text(day.day)
                .font(.subheadline)
                .foregroundStyle(theme.primaryText)

            Image(systemName: day.icon)
                .foregroundStyle(day.color)

            Text("\(day.temp)°")
                .font(.headline)
                .foregroundStyle(theme.primaryText)
        }
        .padding(22)
        .background(theme.cardMaterial, in: RoundedRectangle(cornerRadius: 24))
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel())
        .withAppTheme()
        .preferredColorScheme(.dark)
}
