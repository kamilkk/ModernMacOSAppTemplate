//
//  SettingsCoordinatorView.swift
//  Modern macOS App Template
//
//  Created by Developer on $(date).
//

import SwiftUI

/// Main coordinator view for the Settings feature
struct SettingsCoordinatorView: View {
    @ObservedObject var coordinator: SettingsCoordinator

    var body: some View {
        SettingsView(
            viewModel: coordinator.settingsViewModel,
            selectedTab: $coordinator.selectedSettingsTab,
            onTabChanged: coordinator.switchTab(to:),
            onDismiss: coordinator.dismiss,
            onReset: coordinator.resetToDefaults
        )
    }
}

#Preview {
    SettingsCoordinatorView(coordinator: SettingsCoordinator())
}
