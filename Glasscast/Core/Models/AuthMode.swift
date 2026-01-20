//
//  AuthState.swift
//  Glasscast
//
//  Created by vishwas on 1/18/26.
//

enum AuthMode {
    case signIn
    case signUp

    var title: String {
        switch self {
        case .signIn: return "Glasscast"
        case .signUp: return "Create Account"
        }
    }

    var subtitle: String {
        switch self {
        case .signIn: return "Welcome back"
        case .signUp: return "Create your account"
        }
    }

    var primaryButtonTitle: String {
        switch self {
        case .signIn: return "Sign In"
        case .signUp: return "Sign Up"
        }
    }

    var footerText: String {
        switch self {
        case .signIn: return "Don’t have an account?"
        case .signUp: return "Already have an account?"
        }
    }

    var footerActionText: String {
        switch self {
        case .signIn: return "Sign up"
        case .signUp: return "Sign in"
        }
    }
}
