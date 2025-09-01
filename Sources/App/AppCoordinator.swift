//
//  AppCoordinator.swift
//  Modern macOS App Template
//
//  Created by Developer on $(date).
//

import SwiftUI
import Combine

/// Main application coordinator that manages the overall app flow
@MainActor
final class AppCoordinator: ObservableObject {

    // MARK: - Published Properties
    @Published var currentTab: AppTab = .home
    @Published var isShowingSettings = false

    // MARK: - Child Coordinators
    let homeCoordinator = HomeCoordinator()
    let settingsCoordinator = SettingsCoordinator()

    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization
    init() {
        setupBindings()
    }

    // MARK: - Public Methods
    func showSettings() {
        isShowingSettings = true
    }

    func hideSettings() {
        isShowingSettings = false
    }

    func switchTab(to tab: AppTab) {
        currentTab = tab
    }

    // MARK: - Private Methods
    private func setupBindings() {
        // Listen for settings events from child coordinators
        settingsCoordinator.$shouldDismiss
            .filter { $0 }
            .sink { [weak self] _ in
                self?.hideSettings()
            }
            .store(in: &cancellables)
    }
}

// MARK: - App Tabs
enum AppTab: String, CaseIterable {
    case home = "Home"
    case settings = "Settings"

    var systemImage: String {
        switch self {
        case .home:
            return "house"
        case .settings:
            return "gearshape"
        }
    }
}
