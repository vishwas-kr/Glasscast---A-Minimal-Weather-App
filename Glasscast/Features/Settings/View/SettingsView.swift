//
//  SettingsView.swift
//  Glasscast
//
//  Created by vishwas on 1/19/26.
//
import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @Environment(\.appTheme) var theme
    @AppStorage("appAppearance") private var appearance: AppAppearance = .system

    var body: some View {
        ZStack {
            theme.background
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 28) {
                    header
                    unitsSection
                    accountSection
                    preferencesSection
                    signOutButton
                    appVersion
                }
                .padding()
            }
        }
    }
    var header: some View {
        HStack {

            Text("Settings")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundStyle(theme.primaryText)

            Spacer()
        }
    }

    var unitsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Units")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(theme.secondaryText)

            VStack(spacing: 16) {
                unitToggle(
                    title: "Temperature",
                    left: "°C",
                    right: "°F",
                    isLeftSelected: viewModel.temperatureUnit == .celsius
                ) {
                    viewModel.toggleTemperature()
                }
                Divider()
                    .foregroundStyle(theme.secondaryText)
                unitToggle(
                    title: "Wind Speed",
                    left: "km/h",
                    right: "mph",
                    isLeftSelected: viewModel.windSpeedUnit == .kmh
                ) {
                    viewModel.toggleWindSpeed()
                }
            }
            .padding()
            .background(theme.cardMaterial, in: RoundedRectangle(cornerRadius: 24))
        }
    }

    func unitToggle(
        title: String,
        left: String,
        right: String,
        isLeftSelected: Bool,
        action: @escaping () -> Void
    ) -> some View {
        HStack {
            Text(title)
                .foregroundStyle(theme.primaryText)
            Spacer()

            HStack(spacing: 4) {
                unitButton(left, selected: isLeftSelected, action: action)
                unitButton(right, selected: !isLeftSelected, action: action)
            }
            .padding(4)
            .background(.thinMaterial, in: Capsule())
        }
    }
    func unitButton(
        _ title: String,
        selected: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button {
            withAnimation(.smooth) { action() }
        } label: {
            Text(title)
                .font(.footnote)
                .fontWeight(selected ? .semibold : .regular)
                .foregroundStyle(selected ? .black : theme.secondaryText)
                .frame(width: 52, height: 32)
                .background(
                    selected ? Color.white : Color.clear,
                    in: Capsule()
                )
        }
    }
    var accountSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Account")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(theme.secondaryText)

            VStack(spacing: 12) {
                HStack(spacing: 16) {
                    Image(systemName: "person.fill")
                        .frame(width: 44, height: 44)
                        .background(.thinMaterial, in: Circle())

                    VStack(alignment: .leading, spacing: 4) {
                        Text(viewModel.userName)
                            .fontWeight(.semibold)
                            .foregroundStyle(theme.primaryText)

                        Text(viewModel.email)
                            .font(.caption)
                            .foregroundStyle(theme.secondaryText)
                    }

                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundStyle(theme.secondaryText)
                }

                Divider()

                HStack {
                    Text("Change Password")
                        .foregroundStyle(theme.primaryText)
                    Spacer()
                    Image(systemName: "lock.rotation")
                        .foregroundStyle(theme.secondaryText)
                }
            }
            .padding()
            .background(theme.cardMaterial, in: RoundedRectangle(cornerRadius: 24))
        }
    }
    var preferencesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Preferences")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(theme.secondaryText)

            VStack(spacing: 16) {
                HStack {
                    Label("Appearance", systemImage: "moon")
                        .foregroundStyle(theme.primaryText)
                    Spacer()
                    Menu {
                        Picker("Appearance", selection: $appearance) {
                            ForEach(AppAppearance.allCases) { style in
                                Text(style.displayName).tag(style)
                            }
                        }
                    } label: {
                        Text(appearance.displayName)
                            .foregroundStyle(theme.accent)
                    }
                }
            }
            .padding()
            .background(theme.cardMaterial, in: RoundedRectangle(cornerRadius: 14))
        }
    }
    var signOutButton: some View {
        Button(role: .destructive) {
            UserDefaults.standard.removeObject(forKey: "recent_cities")
            viewModel.signOut()
        } label: {
            Text("Sign Out")
                .frame(maxWidth: .infinity)
                .padding()
                .background(.ultraThinMaterial, in: Capsule())
                .foregroundStyle(.red)
        }
    }
    var appVersion: some View {
        VStack(spacing: 4) {
            Text("GLASSCAST WEATHER APP")
                .font(.caption2)
                .foregroundStyle(theme.secondaryText)

            Text("VERSION 1.0.24 (LIQUID GLASS RC1)")
                .font(.caption2)
                .foregroundStyle(theme.secondaryText)
        }
    }

}
#Preview{
    SettingsView()
}
