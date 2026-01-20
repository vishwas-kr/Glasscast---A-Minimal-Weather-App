//
//  AuthView.swift
//  Glasscast
//
//  Created by vishwas on 1/18/26.
//

import SwiftUI

struct AuthView: View {
    @StateObject private var viewModel = AuthViewModel()
    @FocusState private var focusedEmail: Field?
    @FocusState private var focusedPassword: Field?
    @EnvironmentObject var session: SessionManager
    @Environment(\.appTheme) var theme

    enum Field {
        case email, password
    }

    var body: some View {
        ZStack {
            theme.background
                .ignoresSafeArea()

            VStack {
                Spacer()

                glassCard

                Spacer()
            }
            .padding()
        }
        .animation(.smooth, value: viewModel.isLoading)
        .alert("Error", isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { _ in viewModel.errorMessage = nil }
        )) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage ?? "An unknown error occurred.")
        }
    }
}

// MARK: - Components
private extension AuthView {

    var glassCard: some View {
        GlassEffectContainer{
            VStack(spacing: 24) {
                header
                emailField
                passwordField
                if viewModel.mode == .signIn {
                    forgotPassword
                }
                continueButton
                footer
            }
            .padding(28)
            .background {
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .fill(theme.cardMaterial)
                    .shadow(color: .black.opacity(0.15), radius: 30, y: 20)
            }
        }
       
        //.glassEffect()
    }

    var header: some View {
        VStack(spacing: 8) {
            Text(viewModel.mode.title)
                .font(.system(size: 34, weight: .bold))
                .foregroundStyle(theme.primaryText)

            Text(viewModel.mode.subtitle)
                .font(.system(size: 16))
                .foregroundStyle(theme.secondaryText)
        }
    }


    var emailField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("EMAIL ADDRESS")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(theme.secondaryText)

            HStack {
                Image(systemName: "envelope")
                    .foregroundStyle(theme.secondaryText)

                TextField("name@example.com", text: $viewModel.email)
                    .foregroundStyle(theme.primaryText)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .focused($focusedEmail, equals: .email)
            }
            .padding()
            .foregroundStyle(theme.secondaryText)
            .glassEffect()
        }
    }

    var passwordField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("PASSWORD")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(theme.secondaryText)

            HStack {
                Image(systemName: "lock")
                    .foregroundStyle(theme.secondaryText)

                Group {
                    if viewModel.isPasswordVisible {
                        TextField("••••••••", text: $viewModel.password)
                    } else {
                        SecureField("••••••••", text: $viewModel.password)
                    }
                }
                .focused($focusedPassword, equals: .password)

                Button {
                    withAnimation {
                        viewModel.isPasswordVisible.toggle()
                    }
                } label: {
                    Image(systemName: viewModel.isPasswordVisible ? "eye.slash" : "eye")
                        .foregroundStyle(theme.secondaryText)
                }
            }
            .padding()
            .glassEffect()
        }
    }

    var forgotPassword: some View {
        HStack {
            Spacer()
            Button("Forgot Password?") {}
                .font(.footnote)
                .foregroundStyle(theme.secondaryText)
        }
    }

    var continueButton: some View {
        Button {
            viewModel.submit()
        } label: {
            HStack {
                if viewModel.isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text("Continue")
                        .fontWeight(.semibold)

                    Image(systemName: "arrow.right")
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
        }
        .buttonStyle(AuthButtonStyle())
        .disabled(viewModel.isLoading)
    }

    var footer: some View {
        HStack(spacing: 4) {
            Text(viewModel.mode.footerText)
                .foregroundStyle(theme.secondaryText)

            Button(viewModel.mode.footerActionText) {
                viewModel.toggleMode()
            }
            .fontWeight(.semibold)
            .foregroundStyle(theme.accent)
        }
        .font(.footnote)

    }
}

#Preview{
    AuthView()
}
