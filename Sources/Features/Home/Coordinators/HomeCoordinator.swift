//
//  HomeCoordinator.swift
//  Modern macOS App Template
//
//  Created by Developer on $(date).
//

import SwiftUI
import Combine

/// Coordinator for managing the Home feature navigation and flow
@MainActor
final class HomeCoordinator: ObservableObject {

    // MARK: - Published Properties
    @Published var selectedItem: HomeItem?
    @Published var isShowingDetailSheet = false
    @Published var searchText = ""

    // MARK: - View Models
    let homeViewModel = HomeViewModel()

    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization
    init() {
        setupBindings()
    }

    // MARK: - Public Methods
    func selectItem(_ item: HomeItem) {
        selectedItem = item
        isShowingDetailSheet = true
    }

    func clearSelection() {
        selectedItem = nil
        isShowingDetailSheet = false
    }

    func refreshData() {
        homeViewModel.loadData()
    }

    func search(with text: String) {
        searchText = text
        homeViewModel.filterItems(with: text)
    }

    // MARK: - Private Methods
    private func setupBindings() {
        // Additional bindings can be added here
        homeViewModel.$isLoading
            .sink { isLoading in
                // Handle loading state changes
                print("Home loading state: \(isLoading)")
            }
            .store(in: &cancellables)
    }
}

// MARK: - Home Item Model
struct HomeItem: Identifiable, Hashable, Sendable {
    let id = UUID()
    let title: String
    let subtitle: String
    let systemImage: String
    let category: HomeCategory

    static let samples = [
        HomeItem(title: "Welcome", subtitle: "Getting started with your app", systemImage: "star.fill", category: .featured),
        HomeItem(title: "Documentation", subtitle: "Learn about the features", systemImage: "book.fill", category: .resources),
        HomeItem(title: "Settings", subtitle: "Configure your preferences", systemImage: "gearshape.fill", category: .tools),
        HomeItem(title: "Help", subtitle: "Get support and assistance", systemImage: "questionmark.circle.fill", category: .support)
    ]
}

// MARK: - Home Category
enum HomeCategory: String, CaseIterable, Sendable {
    case featured = "Featured"
    case resources = "Resources"
    case tools = "Tools"
    case support = "Support"

    var systemImage: String {
        switch self {
        case .featured:
            return "star"
        case .resources:
            return "folder"
        case .tools:
            return "wrench"
        case .support:
            return "questionmark.circle"
        }
    }
}
