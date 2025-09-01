//
//  SettingsCoordinator.swift
//  Modern macOS App Template
//
//  Created by Developer on $(date).
//

import SwiftUI
import Combine

/// Coordinator for managing the Settings feature navigation and flow
@MainActor
final class SettingsCoordinator: ObservableObject {

    // MARK: - Published Properties
    @Published var selectedSettingsTab: SettingsTab = .general
    @Published var shouldDismiss = false

    // MARK: - View Models
    let settingsViewModel = SettingsViewModel()

    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization
    init() {
        setupBindings()
    }

    // MARK: - Public Methods
    func switchTab(to tab: SettingsTab) {
        selectedSettingsTab = tab
    }

    func dismiss() {
        shouldDismiss = true
        // Reset the dismiss flag after a short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.shouldDismiss = false
        }
    }

    func resetToDefaults() {
        settingsViewModel.resetToDefaults()
    }

    // MARK: - Private Methods
    private func setupBindings() {
        // Additional bindings can be added here
    }
}

// MARK: - Settings Tab
enum SettingsTab: String, CaseIterable {
    case general = "General"
    case appearance = "Appearance"
    case advanced = "Advanced"
    case about = "About"

    var systemImage: String {
        switch self {
        case .general:
            return "gearshape"
        case .appearance:
            return "paintbrush"
        case .advanced:
            return "slider.horizontal.3"
        case .about:
            return "info.circle"
        }
    }
}
