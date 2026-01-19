//
//  AuthView.swift
//  Glasscast
//
//  Created by vishwas on 1/18/26.
//

import SwiftUI

import SwiftUI

struct AuthView: View {
    @StateObject private var viewModel = AuthViewModel()
    @FocusState private var focusedEmail: Field?
    @FocusState private var focusedPassword: Field?

    enum Field {
        case email, password
    }

    var body: some View {
        ZStack {
            backgroundGradient

            VStack {
                Spacer()

                glassCard

                Spacer()
            }
            .padding()
        }
        .animation(.smooth, value: viewModel.isLoading)
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
                    .fill(.ultraThinMaterial)
                    .shadow(color: .black.opacity(0.15), radius: 30, y: 20)
            }
        }
       
        //.glassEffect()
    }

    var header: some View {
        VStack(spacing: 8) {
            Text(viewModel.mode.title)
                .font(.system(size: 34, weight: .bold))

            Text(viewModel.mode.subtitle)
                .font(.system(size: 16))
                .foregroundStyle(.secondary)
        }
    }


    var emailField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("EMAIL ADDRESS")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)

            HStack {
                Image(systemName: "envelope")
                    .foregroundStyle(.secondary)

                TextField("name@example.com", text: $viewModel.email)
                    .foregroundStyle(.gray)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .focused($focusedEmail, equals: .email)
            }
            .padding()
            .foregroundStyle(.secondary)
            .glassEffect()
        }
    }

    var passwordField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("PASSWORD")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)

            HStack {
                Image(systemName: "lock")
                    .foregroundStyle(.secondary)

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
                        .foregroundStyle(.gray)
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
                .foregroundStyle(.secondary)
        }
    }

    var continueButton: some View {
        Button {
            viewModel.submit(session: SessionManager())
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
                .foregroundStyle(.secondary)

            Button(viewModel.mode.footerActionText) {
                viewModel.toggleMode()
            }
            .fontWeight(.semibold)
        }
        .font(.footnote)

    }

    var backgroundGradient: some View {
        LinearGradient(
            colors: [
                Color(red: 0.75, green: 0.9, blue: 0.97),
                Color(red: 0.85, green: 0.88, blue: 0.95)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
}

#Preview{
    AuthView()
}
