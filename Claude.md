# Glasscast – AI Development Context (CLAUDE.md)

This document defines **project context, rules, architecture, and quality standards** for AI-assisted development of the **Glasscast** weather app. It is intended to be used with **Claude Code or Cursor** to ensure consistent, high-quality output that meets assignment requirements.

---

## 1. Project Overview

**App Name:** Glasscast
**Platform:** iOS (SwiftUI – primary target)
**Architecture:** MVVM (Model–View–ViewModel)
**Design System:** iOS 26 Liquid Glass (glassEffect, translucency, blur, depth)
**Backend:** Supabase (Auth + Database)
**Weather API:** OpenWeatherMap (or equivalent free API)

Glasscast is a **minimal, premium weather app** focused on clarity, polish, and smooth user experience. The app must feel **production-ready**, not a prototype.

---

## 2. Core Requirements (Must Not Be Violated)

### UI & Design

* Use **Liquid Glass design principles** everywhere
* Prefer `.glassEffect()` and `GlassEffectContainer` where applicable
* Glass cards must have:

  * Translucency
  * Blur
  * Rounded corners
  * Subtle shadow & depth
* Smooth animations and transitions
* Support **Light & Dark Mode** via `AppTheme` environment
* Use `theme.background`, `theme.primaryText`, etc. instead of system colors
* No cluttered UI, no placeholder styling

### Architecture

* Strict **MVVM**
* No business logic inside Views
* No networking or Supabase calls inside Views
* All async logic handled in ViewModels or Services

### Code Quality

* Swift concurrency (`async/await`)
* Proper error handling & loading states
* No force unwraps
* No hardcoded secrets
* Clean, readable, modular code

---

## 3. App Architecture

### Folder Structure

```
Glasscast/
├── App/
│   └── GlasscastApp.swift
│   └── RootView.swift
│   └── RootTabView.swift
│
├── Core/
│   ├── Networking/
│   │   ├── WeatherService.swift
│   │   └── APIClient.swift
│   │
│   ├── Theme/
│   │   ├── AppTheme.swift
│   │   ├── Theme.swift
│   │   └── ThemeManager.swift
│   │
│   ├── Supabase/
│   │   ├── SupabaseClient.swift
│   │   ├── AuthManager.swift
│   │   └── FavoritesService.swift
│   │
│   ├── Location/
│   │   └── LocationManager.swift
│   │
│   ├── Models/
│   │   ├── WeatherModels.swift
│   │   └── City.swift
│   │
│   └── Utilities/
│       ├── Constants.swift
│       ├── Environment.swift
│       ├── SessionManager.swift (or AuthManager)
│       └── Extensions/
│
├── Features/
│   ├── Auth/
│   │   ├── View/
│   │   │   └── AuthView.swift
│   │   └── ViewModel/
│   │       └── AuthViewModel.swift
│   │
│   ├── Home/
│   │   ├── View/
│   │   │   └── HomeView.swift
│   │   └── ViewModel/
│   │       └── HomeViewModel.swift
│   │
│   ├── Search/
│   │   ├── View/
│   │   │   └── SearchView.swift
│   │   └── ViewModel/
│   │       └── SearchViewModel.swift
│   │
│   └── Settings/
│       ├── View/
│       │   └── SettingsView.swift
│       └── ViewModel/
│           └── SettingsViewModel.swift
│
└── Resources/
    ├── Assets.xcassets
    └── PreviewData/
```

---

## 4. Screens & Responsibilities

### Auth Screen

**View Responsibilities**

* Render glass UI
* Bind inputs to ViewModel
* Show loading and error states

**ViewModel Responsibilities**

* Email/password validation
* Supabase sign-in & sign-up
* Auth state management

---

### App Entry & Navigation

**RootView**

* Entry point
* Observes `SessionManager`
* Switches between `AuthView` and `RootTabView`

**RootTabView**

* Manage tab navigation (Home, Search, Favorites, Settings)
* Trigger initial location fetch
* Handle communication between Search and Home tabs

---

### Home Screen

**Features**

* Current weather display
* 5-day forecast
* Pull-to-refresh

**ViewModel**

* Fetch weather from API
* Convert temperature units
* Handle loading, error, success states

### Favorites Screen

**Features**

* Dedicated Tab (moved from Home)
* List of favorite cities
* Remove favorites
* Navigate to Home with selected city
* **Logic:** Favorites are matched by location distance (< 2km) to prevent duplicates.

---

### City Search

**Features**

* Search cities (OpenWeather Geo API)
* Recent searches list (Persisted in UserDefaults)
* Add/remove favorites
* Sync with Supabase

**Rules**

* Debounce search input
* Favorites must be user-scoped
* No duplicate cities

---

### Settings

**Features**

* Temperature unit toggle (°C / °F)
* Appearance toggle (System / Light / Dark)
* Wind speed unit toggle (km/h / mph)
* Sign out

**Persistence**

* User preferences stored locally (UserDefaults / AppStorage)

---

## 5. Supabase Rules

### Database Table

`favorite_cities`

* id (uuid)
* user_id (uuid)
* city_name (text)
* lat (double)
* lon (double)
* created_at (timestamp)

### Row Level Security

* Users can only read/write their own rows

### Security

* Supabase URL & anon key stored in `.xcconfig` or environment
* Never hardcode credentials

---

## 6. Networking Standards

* Use a dedicated `WeatherService`
* Decode JSON using `Codable`
* Handle API errors gracefully
* Show user-friendly error messages

---

## 7. Animations & Interaction

* Use `withAnimation(.spring())` or `.smooth`
* Animate:

  * Card appearance
  * State changes
  * Loading indicators
* Pull-to-refresh must feel responsive
* Avoid excessive animation

---

## 8. State Management

Use ObservableObject pattern with explicit published properties:

```
enum ViewState {
    case idle
    case loading
    case loaded
    case error(String)
}
```

Never rely on implicit state.

---

## 9. AI Usage Instructions (Very Important)

Claude/Cursor should:

* Generate **complete files**, not snippets
* Follow MVVM strictly
* Use `@Environment(\.appTheme)` for all styling
* Explain non-obvious decisions briefly
* Prefer correctness over brevity

Claude must NOT:

* Mix UI and business logic
* Skip error handling
* Ignore animations or design polish
* Produce placeholder architecture

---

## 10. Development Workflow (For Screen Recording)

1. Ask Claude to scaffold feature
2. Review architecture
3. Iterate UI polish
4. Fix edge cases
5. Test on simulator
6. Refactor if needed

Narrate thought process during AI usage.

---

## 11. Definition of Done

A feature is complete only if:

* UI matches Liquid Glass design
* MVVM separation is clean
* Error & loading states exist
* Animations feel smooth
* No crashes occur

---

## 12. Goal

Glasscast should feel like:

> “An Apple-designed weather app built with modern AI-assisted workflows.”

This file is the **single source of truth** for AI-assisted development.
