//
//  AppConstants.swift
//  Modern macOS App Template
//
//  Created by Developer on $(date).
//

import Foundation

/// Application-wide constants
enum AppConstants {

    // MARK: - App Information
    enum App {
        static let name = "Modern macOS App Template"
        static let bundleIdentifier = "com.yourcompany.modern-macos-app-template"
        static let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
        static let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }

    // MARK: - User Defaults Keys
    enum UserDefaultsKeys {
        static let hasLaunchedBefore = "hasLaunchedBefore"
        static let selectedTheme = "selectedTheme"
        static let lastOpenedDate = "lastOpenedDate"
        static let userPreferences = "userPreferences"
    }

    // MARK: - Animation Durations
    enum Animation {
        static let short: Double = 0.2
        static let medium: Double = 0.3
        static let long: Double = 0.5
    }

    // MARK: - Layout Constants
    enum Layout {
        static let cornerRadius: CGFloat = 12
        static let shadowRadius: CGFloat = 4
        static let standardPadding: CGFloat = 16
        static let compactPadding: CGFloat = 8
        static let minimumTouchTarget: CGFloat = 44
    }

    // MARK: - URLs
    enum URLs {
        static let website = URL(string: "https://example.com")!
        static let support = URL(string: "https://example.com/support")!
        static let privacyPolicy = URL(string: "https://example.com/privacy")!
        static let termsOfService = URL(string: "https://example.com/terms")!
    }

    // MARK: - File Paths
    enum FilePaths {
        static let documents = FileManager.documentsDirectory
        static let applicationSupport = FileManager.applicationSupportDirectory
        static let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    }

    // MARK: - Network
    enum Network {
        static let baseURL = "https://api.example.com"
        static let timeout: TimeInterval = 30
        static let retryCount = 3
    }

    // MARK: - Feature Flags
    enum Features {
        static let enableAnalytics = true
        static let enableCrashReporting = true
        static let enableDebugMode = false
        static let enableBetaFeatures = false
    }
}
