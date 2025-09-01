//
//  HomeCoordinatorView.swift
//  Modern macOS App Template
//
//  Created by Developer on $(date).
//

import SwiftUI

/// Main coordinator view for the Home feature
struct HomeCoordinatorView: View {
    @ObservedObject var coordinator: HomeCoordinator

    var body: some View {
        HomeView(
            viewModel: coordinator.homeViewModel,
            onItemSelected: coordinator.selectItem(_:),
            onRefresh: coordinator.refreshData,
            onSearch: coordinator.search(with:)
        )
        .sheet(item: $coordinator.selectedItem) { item in
            HomeDetailSheet(
                item: item,
                onDismiss: coordinator.clearSelection
            )
        }
    }
}

// MARK: - Home Detail Sheet
private struct HomeDetailSheet: View {
    let item: HomeItem
    let onDismiss: () -> Void

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: item.systemImage)
                    .font(.system(size: 64))
                    .foregroundColor(.accentColor)

                VStack(spacing: 8) {
                    Text(item.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text(item.subtitle)
                        .font(.title2)
                        .foregroundColor(.secondary)
                }

                Text(item.category.rawValue)
                    .font(.caption)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(.quaternary)
                    .clipShape(Capsule())

                Spacer()

                Button("Done") {
                    onDismiss()
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
            .padding()
            .frame(width: 400, height: 300)
            .navigationTitle("Item Details")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        onDismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    HomeCoordinatorView(coordinator: HomeCoordinator())
}
