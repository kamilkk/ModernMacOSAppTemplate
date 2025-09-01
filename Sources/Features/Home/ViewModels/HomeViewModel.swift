//
//  HomeViewModel.swift
//  Modern macOS App Template
//
//  Created by Developer on $(date).
//

import SwiftUI
import Combine

/// ViewModel for managing Home feature data and business logic
@MainActor
final class HomeViewModel: ObservableObject {

    // MARK: - Published Properties
    @Published var items: [HomeItem] = []
    @Published var filteredItems: [HomeItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedCategory: HomeCategory?

    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    private let dataService: HomeDataService

    // MARK: - Initialization
    init(dataService: HomeDataService = HomeDataService()) {
        self.dataService = dataService
        loadData()
    }

    // MARK: - Public Methods
    func loadData() {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let fetchedItems = try await dataService.fetchHomeItems()
                await MainActor.run {
                    self.items = fetchedItems
                    self.filteredItems = fetchedItems
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }

    func filterItems(with searchText: String) {
        if searchText.isEmpty {
            filteredItems = items
        } else {
            filteredItems = items.filter { item in
                item.title.localizedCaseInsensitiveContains(searchText) ||
                item.subtitle.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    func filterByCategory(_ category: HomeCategory?) {
        selectedCategory = category

        if let category = category {
            filteredItems = items.filter { $0.category == category }
        } else {
            filteredItems = items
        }
    }

    func refreshData() {
        loadData()
    }

    // MARK: - Computed Properties
    var categorizedItems: [HomeCategory: [HomeItem]] {
        Dictionary(grouping: filteredItems) { $0.category }
    }

    var hasError: Bool {
        errorMessage != nil
    }
}

// MARK: - Home Data Service
final class HomeDataService: Sendable {

    func fetchHomeItems() async throws -> [HomeItem] {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second

        // Return sample data (in a real app, this would fetch from API/database)
        return HomeItem.samples
    }
}
