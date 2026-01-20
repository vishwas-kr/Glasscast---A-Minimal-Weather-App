//
//  RootTabView.swift
//  Glasscast
//
//  Created by vishwas on 1/19/26.
//

import SwiftUI
import CoreLocation

struct RootTabView: View {
    @StateObject private var homeViewModel = HomeViewModel()
    @State private var selectedTab: AppTab = .home

    var body: some View {
        ZStack(alignment: .bottom) {
            content
            tabBar
        }
        .ignoresSafeArea(edges: .bottom)
        .task {
            homeViewModel.requestLocation()
        }
    }
}

#Preview {
    RootTabView()
}

private extension RootTabView {
    @ViewBuilder
    var content: some View {
        ZStack {
            switch selectedTab {
            case .home:
                HomeView(viewModel: homeViewModel)
                    .transition(.opacity.combined(with: .move(edge: .leading)))

            case .search:
                SearchView(onCitySelected: { location in
                    homeViewModel.loadWeather(for: location)
                    selectedTab = .home
                })
                    .transition(.opacity.combined(with: .move(edge: .trailing)))

            case .favorites:
                FavoritesView { location in
                    homeViewModel.loadWeather(for: location)
                    selectedTab = .home
                }
                .transition(.opacity.combined(with: .move(edge: .trailing)))

            case .settings:
                SettingsView()
                    .transition(.opacity.combined(with: .move(edge: .trailing)))
            }
        }
        .animation(.smooth, value: selectedTab)
    }
}

private extension RootTabView {
    var tabBar: some View {
        HStack(spacing: 40) {
            ForEach(AppTab.allCases, id: \.self) { tab in
                tabButton(tab)
            }
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 32)
        .background(
            Capsule()
                .fill(.ultraThinMaterial)
                .shadow(radius: 20)
        )
        .padding(.bottom, 24)
    }
    
    func tabButton(_ tab: AppTab) -> some View {
        Button {
            withAnimation(.smooth) {
                selectedTab = tab
            }
        } label: {
            Image(systemName: tab.icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(
                    selectedTab == tab ? .blue : .secondary
                )
                .frame(width: 44, height: 44)
                .background {
                    if selectedTab == tab {
                        Circle()
                            .fill(.thinMaterial)
                            .transition(.scale)
                    }
                }
        }
    }

}


