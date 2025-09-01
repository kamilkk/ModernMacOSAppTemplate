//
//  AppCoordinatorView.swift
//  Modern macOS App Template
//
//  Created by Developer on $(date).
//

import SwiftUI

/// Main coordinator view that manages the app's navigation structure
struct AppCoordinatorView: View {
    @ObservedObject var coordinator: AppCoordinator

    var body: some View {
        NavigationSplitView {
            SidebarView(coordinator: coordinator)
                .navigationSplitViewColumnWidth(min: 200, ideal: 250, max: 300)
        } detail: {
            DetailView(coordinator: coordinator)
        }
        .sheet(isPresented: $coordinator.isShowingSettings) {
            SettingsSheetView(coordinator: coordinator.settingsCoordinator)
        }
    }
}

// MARK: - Sidebar View
private struct SidebarView: View {
    @ObservedObject var coordinator: AppCoordinator

    var body: some View {
        List(selection: $coordinator.currentTab) {
            ForEach(AppTab.allCases, id: \.self) { tab in
                NavigationLink(value: tab) {
                    Label(tab.rawValue, systemImage: tab.systemImage)
                }
            }

            Section("Actions") {
                Button("Settings") {
                    coordinator.showSettings()
                }
                .buttonStyle(.plain)
            }
        }
        .navigationTitle("Modern App")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Settings") {
                    coordinator.showSettings()
                }
            }
        }
    }
}

// MARK: - Detail View
private struct DetailView: View {
    @ObservedObject var coordinator: AppCoordinator

    var body: some View {
        Group {
            switch coordinator.currentTab {
            case .home:
                HomeCoordinatorView(coordinator: coordinator.homeCoordinator)
            case .settings:
                SettingsCoordinatorView(coordinator: coordinator.settingsCoordinator)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Settings Sheet View
private struct SettingsSheetView: View {
    @ObservedObject var coordinator: SettingsCoordinator

    var body: some View {
        SettingsCoordinatorView(coordinator: coordinator)
            .frame(width: 500, height: 400)
    }
}

#Preview {
    AppCoordinatorView(coordinator: AppCoordinator())
}
