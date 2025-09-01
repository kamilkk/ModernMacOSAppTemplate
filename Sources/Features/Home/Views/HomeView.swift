//
//  HomeView.swift
//  Modern macOS App Template
//
//  Created by Developer on $(date).
//

import SwiftUI

/// Main view for the Home feature
struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel

    let onItemSelected: (HomeItem) -> Void
    let onRefresh: () -> Void
    let onSearch: (String) -> Void

    @State private var searchText = ""
    @State private var selectedCategory: HomeCategory?

    var body: some View {
        VStack(spacing: 0) {
            HeaderView(
                searchText: $searchText,
                selectedCategory: $selectedCategory,
                onSearch: onSearch,
                onCategorySelected: { category in
                    selectedCategory = category
                    viewModel.filterByCategory(category)
                },
                onRefresh: onRefresh
            )

            Divider()

            ContentView(
                viewModel: viewModel,
                onItemSelected: onItemSelected
            )
        }
        .navigationTitle("Home")
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                RefreshButton(onRefresh: onRefresh)
            }
        }
        .onAppear {
            if viewModel.items.isEmpty {
                viewModel.loadData()
            }
        }
        .onChange(of: searchText) { newValue in
            onSearch(newValue)
        }
    }
}

// MARK: - Header View
private struct HeaderView: View {
    @Binding var searchText: String
    @Binding var selectedCategory: HomeCategory?

    let onSearch: (String) -> Void
    let onCategorySelected: (HomeCategory?) -> Void
    let onRefresh: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            // Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)

                TextField("Search items...", text: $searchText)
                    .textFieldStyle(.roundedBorder)

                if !searchText.isEmpty {
                    Button("Clear") {
                        searchText = ""
                        onSearch("")
                    }
                    .buttonStyle(.borderless)
                }
            }

            // Category Filter
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    CategoryFilterButton(
                        title: "All",
                        isSelected: selectedCategory == nil
                    ) {
                        selectedCategory = nil
                        onCategorySelected(nil)
                    }

                    ForEach(HomeCategory.allCases, id: \.self) { category in
                        CategoryFilterButton(
                            title: category.rawValue,
                            systemImage: category.systemImage,
                            isSelected: selectedCategory == category
                        ) {
                            selectedCategory = category
                            onCategorySelected(category)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding()
    }
}

// MARK: - Category Filter Button
private struct CategoryFilterButton: View {
    let title: String
    let systemImage: String?
    let isSelected: Bool
    let action: () -> Void

    init(title: String, systemImage: String? = nil, isSelected: Bool, action: @escaping () -> Void) {
        self.title = title
        self.systemImage = systemImage
        self.isSelected = isSelected
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if let systemImage = systemImage {
                    Image(systemName: systemImage)
                        .font(.caption)
                }
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(isSelected ? .blue : Color(white: 0.9))
            .foregroundColor(isSelected ? .white : .primary)
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Content View
private struct ContentView: View {
    @ObservedObject var viewModel: HomeViewModel
    let onItemSelected: (HomeItem) -> Void

    var body: some View {
        Group {
            if viewModel.isLoading {
                LoadingView()
            } else if viewModel.hasError {
                ErrorView(
                    message: viewModel.errorMessage ?? "Unknown error",
                    onRetry: viewModel.refreshData
                )
            } else if viewModel.filteredItems.isEmpty {
                EmptyView()
            } else {
                ItemsGridView(
                    items: viewModel.filteredItems,
                    onItemSelected: onItemSelected
                )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Items Grid View
private struct ItemsGridView: View {
    let items: [HomeItem]
    let onItemSelected: (HomeItem) -> Void

    private let columns = [
        GridItem(.adaptive(minimum: 200, maximum: 300), spacing: 16)
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(items) { item in
                    HomeItemCard(item: item) {
                        onItemSelected(item)
                    }
                }
            }
            .padding()
        }
    }
}

// MARK: - Home Item Card
private struct HomeItemCard: View {
    let item: HomeItem
    let onTap: () -> Void

    @State private var isHovered = false

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: item.systemImage)
                        .font(.title2)
                        .foregroundColor(.accentColor)

                    Spacer()

                    Text(item.category.rawValue)
                        .font(.caption2)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.quaternary)
                        .clipShape(Capsule())
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .lineLimit(1)

                    Text(item.subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }

                Spacer()
            }
            .padding()
            .frame(height: 120)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isHovered ? .blue : .clear, lineWidth: 2)
            )
            .scaleEffect(isHovered ? 1.02 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isHovered)
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            isHovered = hovering
        }
    }
}

// MARK: - Helper Views
private struct LoadingView: View {
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
            Text("Loading...")
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct ErrorView: View {
    let message: String
    let onRetry: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundColor(.orange)

            Text("Something went wrong")
                .font(.headline)

            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            Button("Try Again") {
                onRetry()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct EmptyView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "tray")
                .font(.system(size: 48))
                .foregroundColor(.secondary)

            Text("No items found")
                .font(.headline)
                .foregroundColor(.secondary)

            Text("Try adjusting your search or filter criteria")
                .font(.subheadline)
                .foregroundStyle(.tertiary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct RefreshButton: View {
    let onRefresh: () -> Void

    var body: some View {
        Button("Refresh", systemImage: "arrow.clockwise") {
            onRefresh()
        }
    }
}

#Preview {
    NavigationView {
        HomeView(
            viewModel: HomeViewModel(),
            onItemSelected: { _ in },
            onRefresh: { },
            onSearch: { _ in }
        )
    }
}
