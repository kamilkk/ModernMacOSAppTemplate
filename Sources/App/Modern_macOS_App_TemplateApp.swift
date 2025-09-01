//
//  Modern_macOS_App_TemplateApp.swift
//  Modern macOS App Template
//
//  Created by Developer on $(date).
//

import SwiftUI

@main
struct ModernMacOSAppTemplateApp: App {
    @StateObject private var appCoordinator = AppCoordinator()

    var body: some Scene {
        WindowGroup {
            AppCoordinatorView(coordinator: appCoordinator)
                .frame(minWidth: 900, maxWidth: .infinity, minHeight: 600, maxHeight: .infinity)
        }
        .windowStyle(.hiddenTitleBar)
        .windowToolbarStyle(.unified(showsTitle: false))
        .commands {
            CommandGroup(replacing: .newItem) { }
            CommandGroup(replacing: .undoRedo) { }
            CommandGroup(replacing: .pasteboard) { }
        }

        Settings {
            SettingsCoordinatorView(coordinator: appCoordinator.settingsCoordinator)
        }
    }
}
