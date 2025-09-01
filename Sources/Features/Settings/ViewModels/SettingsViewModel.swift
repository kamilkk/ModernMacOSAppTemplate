//
//  SettingsViewModel.swift
//  Modern macOS App Template
//
//  Created by Developer on $(date).
//

import SwiftUI
import Combine

/// ViewModel for managing Settings feature data and user preferences
@MainActor
final class SettingsViewModel: ObservableObject {

    // MARK: - Published Properties

    // General Settings
    @Published var appName = "Modern macOS App Template"
    @Published var enableNotifications = true
    @Published var autoSave = false
    @Published var maxRecentItems = 10

    // Appearance Settings
    @Published var selectedTheme: AppTheme = .system
    @Published var useSystemAccentColor = true
    @Published var customAccentColor: Color = .blue
    @Published var showSidebar = true
    @Published var sidebarWidth: Double = 250

    // Advanced Settings
    @Published var enableDebugMode = false
    @Published var maxCacheSize = 100
    @Published var enableAnalytics = true
    @Published var dataRetentionDays = 30

    // About Information
    let appVersion = "1.0.0"
    let buildNumber = "1"
    let copyrightText = "© 2024 Your Company Name"

    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    private let userDefaults = UserDefaults.standard

    // MARK: - Initialization
    init() {
        loadSettings()
        setupBindings()
    }

    // MARK: - Public Methods
    func saveSettings() {
        // General Settings
        userDefaults.set(enableNotifications, forKey: "enableNotifications")
        userDefaults.set(autoSave, forKey: "autoSave")
        userDefaults.set(maxRecentItems, forKey: "maxRecentItems")

        // Appearance Settings
        userDefaults.set(selectedTheme.rawValue, forKey: "selectedTheme")
        userDefaults.set(useSystemAccentColor, forKey: "useSystemAccentColor")
        userDefaults.set(showSidebar, forKey: "showSidebar")
        userDefaults.set(sidebarWidth, forKey: "sidebarWidth")

        // Advanced Settings
        userDefaults.set(enableDebugMode, forKey: "enableDebugMode")
        userDefaults.set(maxCacheSize, forKey: "maxCacheSize")
        userDefaults.set(enableAnalytics, forKey: "enableAnalytics")
        userDefaults.set(dataRetentionDays, forKey: "dataRetentionDays")

        // Save custom accent color as data
        if let colorData = try? NSKeyedArchiver.archivedData(withRootObject: NSColor(customAccentColor), requiringSecureCoding: false) {
            userDefaults.set(colorData, forKey: "customAccentColor")
        }
    }

    func resetToDefaults() {
        // Reset to default values
        enableNotifications = true
        autoSave = false
        maxRecentItems = 10
        selectedTheme = .system
        useSystemAccentColor = true
        customAccentColor = .blue
        showSidebar = true
        sidebarWidth = 250
        enableDebugMode = false
        maxCacheSize = 100
        enableAnalytics = true
        dataRetentionDays = 30

        // Clear user defaults
        let keys = ["enableNotifications", "autoSave", "maxRecentItems", "selectedTheme", 
                   "useSystemAccentColor", "customAccentColor", "showSidebar", "sidebarWidth",
                   "enableDebugMode", "maxCacheSize", "enableAnalytics", "dataRetentionDays"]

        keys.forEach { userDefaults.removeObject(forKey: $0) }

        saveSettings()
    }

    func clearCache() {
        // Implement cache clearing logic
        print("Cache cleared")
    }

    func exportSettings() -> String {
        let settings: [String: Any] = [
            "enableNotifications": enableNotifications,
            "autoSave": autoSave,
            "maxRecentItems": maxRecentItems,
            "selectedTheme": selectedTheme.rawValue,
            "useSystemAccentColor": useSystemAccentColor,
            "showSidebar": showSidebar,
            "sidebarWidth": sidebarWidth,
            "enableDebugMode": enableDebugMode,
            "maxCacheSize": maxCacheSize,
            "enableAnalytics": enableAnalytics,
            "dataRetentionDays": dataRetentionDays
        ]

        if let data = try? JSONSerialization.data(withJSONObject: settings, options: .prettyPrinted),
           let jsonString = String(data: data, encoding: .utf8) {
            return jsonString
        }

        return "{}"
    }

    // MARK: - Private Methods
    private func loadSettings() {
        // Load General Settings
        enableNotifications = userDefaults.bool(forKey: "enableNotifications") 
        autoSave = userDefaults.bool(forKey: "autoSave")
        maxRecentItems = userDefaults.object(forKey: "maxRecentItems") as? Int ?? 10

        // Load Appearance Settings
        if let themeRawValue = userDefaults.string(forKey: "selectedTheme"),
           let theme = AppTheme(rawValue: themeRawValue) {
            selectedTheme = theme
        }
        useSystemAccentColor = userDefaults.object(forKey: "useSystemAccentColor") as? Bool ?? true
        showSidebar = userDefaults.object(forKey: "showSidebar") as? Bool ?? true
        sidebarWidth = userDefaults.object(forKey: "sidebarWidth") as? Double ?? 250

        // Load custom accent color
        if let colorData = userDefaults.data(forKey: "customAccentColor"),
           let nsColor = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSColor.self, from: colorData) {
            customAccentColor = Color(nsColor)
        }

        // Load Advanced Settings
        enableDebugMode = userDefaults.bool(forKey: "enableDebugMode")
        maxCacheSize = userDefaults.object(forKey: "maxCacheSize") as? Int ?? 100
        enableAnalytics = userDefaults.object(forKey: "enableAnalytics") as? Bool ?? true
        dataRetentionDays = userDefaults.object(forKey: "dataRetentionDays") as? Int ?? 30
    }

    private func setupBindings() {
        // Auto-save settings when they change
        Publishers.CombineLatest4(
            $enableNotifications,
            $autoSave,
            $maxRecentItems,
            $selectedTheme
        )
        .dropFirst() // Skip initial emission
        .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
        .sink { [weak self] _, _, _, _ in
            self?.saveSettings()
        }
        .store(in: &cancellables)

        Publishers.CombineLatest4(
            $useSystemAccentColor,
            $customAccentColor,
            $showSidebar,
            $sidebarWidth
        )
        .dropFirst()
        .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
        .sink { [weak self] _, _, _, _ in
            self?.saveSettings()
        }
        .store(in: &cancellables)

        Publishers.CombineLatest4(
            $enableDebugMode,
            $maxCacheSize,
            $enableAnalytics,
            $dataRetentionDays
        )
        .dropFirst()
        .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
        .sink { [weak self] _, _, _, _ in
            self?.saveSettings()
        }
        .store(in: &cancellables)
    }
}

// MARK: - App Theme
enum AppTheme: String, CaseIterable {
    case light = "Light"
    case dark = "Dark"
    case system = "System"

    var colorScheme: ColorScheme? {
        switch self {
        case .light:
            return .light
        case .dark:
            return .dark
        case .system:
            return nil
        }
    }
}
