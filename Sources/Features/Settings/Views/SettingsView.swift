//
//  SettingsView.swift
//  Modern macOS App Template
//
//  Created by Developer on $(date).
//

import SwiftUI

/// Main view for the Settings feature
struct SettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel
    @Binding var selectedTab: SettingsTab

    let onTabChanged: (SettingsTab) -> Void
    let onDismiss: () -> Void
    let onReset: () -> Void

    var body: some View {
        HSplitView {
            // Sidebar
            SettingsSidebar(
                selectedTab: $selectedTab,
                onTabChanged: onTabChanged
            )
            .frame(minWidth: 180, maxWidth: 200)

            // Content
            SettingsContent(
                viewModel: viewModel,
                selectedTab: selectedTab
            )
            .frame(minWidth: 400)
        }
        .navigationTitle("Settings")
        .toolbar {
            ToolbarItemGroup(placement: .cancellationAction) {
                Button("Reset to Defaults") {
                    onReset()
                }
            }

            ToolbarItemGroup(placement: .confirmationAction) {
                Button("Done") {
                    onDismiss()
                }
                .keyboardShortcut(.return)
            }
        }
    }
}

// MARK: - Settings Sidebar
private struct SettingsSidebar: View {
    @Binding var selectedTab: SettingsTab
    let onTabChanged: (SettingsTab) -> Void

    var body: some View {
        List(selection: $selectedTab) {
            ForEach(SettingsTab.allCases, id: \.self) { tab in
                NavigationLink(value: tab) {
                    Label(tab.rawValue, systemImage: tab.systemImage)
                }
            }
        }
        .listStyle(.sidebar)
        .onChange(of: selectedTab) { newTab in
            onTabChanged(newTab)
        }
    }
}

// MARK: - Settings Content
private struct SettingsContent: View {
    @ObservedObject var viewModel: SettingsViewModel
    let selectedTab: SettingsTab

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                switch selectedTab {
                case .general:
                    GeneralSettingsView(viewModel: viewModel)
                case .appearance:
                    AppearanceSettingsView(viewModel: viewModel)
                case .advanced:
                    AdvancedSettingsView(viewModel: viewModel)
                case .about:
                    AboutSettingsView(viewModel: viewModel)
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

// MARK: - General Settings View
private struct GeneralSettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel

    var body: some View {
        SettingsSection("General") {
            VStack(alignment: .leading, spacing: 16) {
                LabeledContent("App Name:") {
                    TextField("App Name", text: $viewModel.appName)
                        .textFieldStyle(.roundedBorder)
                        .frame(maxWidth: 200)
                }

                Toggle("Enable Notifications", isOn: $viewModel.enableNotifications)

                Toggle("Auto Save", isOn: $viewModel.autoSave)

                LabeledContent("Max Recent Items:") {
                    Stepper("\(viewModel.maxRecentItems)", value: $viewModel.maxRecentItems, in: 5...50)
                        .frame(maxWidth: 150)
                }
            }
        }
    }
}

// MARK: - Appearance Settings View
private struct AppearanceSettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel

    var body: some View {
        SettingsSection("Appearance") {
            VStack(alignment: .leading, spacing: 16) {
                LabeledContent("Theme:") {
                    Picker("Theme", selection: $viewModel.selectedTheme) {
                        ForEach(AppTheme.allCases, id: \.self) { theme in
                            Text(theme.rawValue).tag(theme)
                        }
                    }
                    .pickerStyle(.segmented)
                    .frame(maxWidth: 300)
                }

                Toggle("Use System Accent Color", isOn: $viewModel.useSystemAccentColor)

                if !viewModel.useSystemAccentColor {
                    LabeledContent("Custom Accent Color:") {
                        ColorPicker("Accent Color", selection: $viewModel.customAccentColor)
                            .frame(maxWidth: 100)
                    }
                }

                Toggle("Show Sidebar", isOn: $viewModel.showSidebar)

                if viewModel.showSidebar {
                    LabeledContent("Sidebar Width:") {
                        Slider(value: $viewModel.sidebarWidth, in: 150...400, step: 10) {
                            Text("Width")
                        } minimumValueLabel: {
                            Text("150")
                        } maximumValueLabel: {
                            Text("400")
                        }
                        .frame(maxWidth: 300)

                        Text("\(Int(viewModel.sidebarWidth))px")
                            .foregroundColor(.secondary)
                            .font(.caption)
                    }
                }
            }
        }
    }
}

// MARK: - Advanced Settings View
private struct AdvancedSettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel

    var body: some View {
        SettingsSection("Advanced") {
            VStack(alignment: .leading, spacing: 16) {
                Toggle("Enable Debug Mode", isOn: $viewModel.enableDebugMode)
                    .help("Enables additional logging and debugging features")

                LabeledContent("Max Cache Size (MB):") {
                    Stepper("\(viewModel.maxCacheSize)", value: $viewModel.maxCacheSize, in: 50...1000, step: 50)
                        .frame(maxWidth: 150)
                }

                Toggle("Enable Analytics", isOn: $viewModel.enableAnalytics)
                    .help("Helps improve the app by sending anonymous usage data")

                LabeledContent("Data Retention (days):") {
                    Stepper("\(viewModel.dataRetentionDays)", value: $viewModel.dataRetentionDays, in: 1...365)
                        .frame(maxWidth: 150)
                }

                HStack {
                    Button("Clear Cache") {
                        viewModel.clearCache()
                    }
                    .buttonStyle(.bordered)

                    Button("Export Settings") {
                        let settings = viewModel.exportSettings()
                        let pasteboard = NSPasteboard.general
                        pasteboard.clearContents()
                        pasteboard.setString(settings, forType: .string)
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
    }
}

// MARK: - About Settings View
private struct AboutSettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel

    var body: some View {
        SettingsSection("About") {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(viewModel.appName)
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("Version \(viewModel.appVersion) (\(viewModel.buildNumber))")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Text(viewModel.copyrightText)
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }

                Divider()

                VStack(alignment: .leading, spacing: 12) {
                    Text("System Information")
                        .font(.headline)

                    Grid(alignment: .leading, horizontalSpacing: 16, verticalSpacing: 8) {
                        GridRow {
                            Text("macOS:")
                            Text(ProcessInfo.processInfo.operatingSystemVersionString)
                                .foregroundColor(.secondary)
                        }

                        GridRow {
                            Text("Architecture:")
                            Text(ProcessInfo.processInfo.machineHardwareName ?? "Unknown")
                                .foregroundColor(.secondary)
                        }

                        GridRow {
                            Text("Memory:")
                            Text(ByteCountFormatter.string(fromByteCount: Int64(ProcessInfo.processInfo.physicalMemory), countStyle: .memory))
                                .foregroundColor(.secondary)
                        }
                    }
                }

                Divider()

                VStack(alignment: .leading, spacing: 12) {
                    Text("Links")
                        .font(.headline)

                    VStack(alignment: .leading, spacing: 8) {
                        Link("Website", destination: URL(string: "https://example.com")!)
                        Link("Support", destination: URL(string: "https://example.com/support")!)
                        Link("Privacy Policy", destination: URL(string: "https://example.com/privacy")!)
                    }
                }
            }
        }
    }
}

// MARK: - Settings Section Helper
private struct SettingsSection<Content: View>: View {
    let title: String
    let content: Content

    init(_ title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)

            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 24)
    }
}

// MARK: - ProcessInfo Extension
private extension ProcessInfo {
    var machineHardwareName: String? {
        var sysinfo = utsname()
        let result = uname(&sysinfo)
        guard result == EXIT_SUCCESS else { return nil }

        let data = Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN))
        guard let identifier = String(bytes: data, encoding: .ascii) else { return nil }
        return identifier.trimmingCharacters(in: .controlCharacters)
    }
}

#Preview {
    NavigationView {
        SettingsView(
            viewModel: SettingsViewModel(),
            selectedTab: .constant(.general),
            onTabChanged: { _ in },
            onDismiss: { },
            onReset: { }
        )
    }
    .frame(width: 700, height: 500)
}
