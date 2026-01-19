//
//  SettingsView.swift
//  Glasscast
//
//  Created by vishwas on 1/19/26.
//
import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()

    var body: some View {
        ZStack {
            background
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

            Spacer()
        }
    }

    var unitsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Units")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)

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
                    .foregroundStyle(.secondary)
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
            .background(.ultraThickMaterial, in: RoundedRectangle(cornerRadius: 24))
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
                .foregroundStyle(selected ? .black : .secondary)
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
                .foregroundStyle(.secondary)

            VStack(spacing: 12) {
                HStack(spacing: 16) {
                    Image(systemName: "person.fill")
                        .frame(width: 44, height: 44)
                        .background(.thinMaterial, in: Circle())

                    VStack(alignment: .leading, spacing: 4) {
                        Text(viewModel.userName)
                            .fontWeight(.semibold)

                        Text(viewModel.email)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()
                    Image(systemName: "chevron.right")
                }

                Divider()

                HStack {
                    Text("Change Password")
                    Spacer()
                    Image(systemName: "lock.rotation")
                }
            }
            .padding()
            .background(.ultraThickMaterial, in: RoundedRectangle(cornerRadius: 24))
        }
    }
    var preferencesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Preferences")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)

            VStack(spacing: 16) {
                HStack {
                    Label("Appearance", systemImage: "moon")
                    Spacer()
                    Text("System")
                        .foregroundStyle(.blue)
                }
            }
            .padding()
            .background(.ultraThickMaterial, in: RoundedRectangle(cornerRadius: 14))
        }
    }
    var signOutButton: some View {
        Button(role: .destructive) {
            viewModel.signOut()
        } label: {
            Text("Sign Out")
                .frame(maxWidth: .infinity)
                .padding()
                .background(.ultraThinMaterial, in: Capsule())
        }
    }
    var appVersion: some View {
        VStack(spacing: 4) {
            Text("GLASSCAST WEATHER APP")
                .font(.caption2)
                .foregroundStyle(.secondary)

            Text("VERSION 1.0.24 (LIQUID GLASS RC1)")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }

}
#Preview{
    SettingsView()
}
private extension SettingsView {
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

