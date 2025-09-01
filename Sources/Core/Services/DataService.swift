//
//  DataService.swift
//  Modern macOS App Template
//
//  Created by Developer on $(date).
//

import Foundation
import Combine

/// Protocol for data service implementations
protocol DataServiceProtocol {
    func fetchItems() async throws -> [DataItem]
    func saveItem(_ item: DataItem) async throws
    func deleteItem(id: UUID) async throws
}

/// Mock data service for development and testing
class MockDataService: DataServiceProtocol {

    private var items: [DataItem] = []

    init() {
        // Initialize with sample data
        items = DataItem.sampleItems
    }

    func fetchItems() async throws -> [DataItem] {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        return items
    }

    func saveItem(_ item: DataItem) async throws {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item
        } else {
            items.append(item)
        }
    }

    func deleteItem(id: UUID) async throws {
        items.removeAll { $0.id == id }
    }
}

/// Real data service implementation (replace with your actual backend)
class NetworkDataService: DataServiceProtocol {

    private let baseURL = AppConstants.Network.baseURL
    private let session = URLSession.shared

    func fetchItems() async throws -> [DataItem] {
        guard let url = URL(string: "\(baseURL)/items") else {
            throw DataServiceError.invalidURL
        }

        let (data, response) = try await session.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw DataServiceError.networkError
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        return try decoder.decode([DataItem].self, from: data)
    }

    func saveItem(_ item: DataItem) async throws {
        guard let url = URL(string: "\(baseURL)/items") else {
            throw DataServiceError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        request.httpBody = try encoder.encode(item)

        let (_, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw DataServiceError.saveFailed
        }
    }

    func deleteItem(id: UUID) async throws {
        guard let url = URL(string: "\(baseURL)/items/\(id)") else {
            throw DataServiceError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        let (_, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw DataServiceError.deleteFailed
        }
    }
}

// MARK: - Data Service Errors
enum DataServiceError: LocalizedError {
    case invalidURL
    case networkError
    case saveFailed
    case deleteFailed
    case decodingError

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .networkError:
            return "Network error occurred"
        case .saveFailed:
            return "Failed to save item"
        case .deleteFailed:
            return "Failed to delete item"
        case .decodingError:
            return "Failed to decode data"
        }
    }
}

// MARK: - Data Item Model
struct DataItem: Identifiable, Codable, Hashable {
    let id: UUID
    let title: String
    let subtitle: String
    let category: String
    let createdAt: Date
    let updatedAt: Date

    init(
        id: UUID = UUID(),
        title: String,
        subtitle: String,
        category: String,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.category = category
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    static let sampleItems = [
        DataItem(title: "Sample Item 1", subtitle: "This is a sample item", category: "General"),
        DataItem(title: "Sample Item 2", subtitle: "Another sample item", category: "Work"),
        DataItem(title: "Sample Item 3", subtitle: "Yet another sample", category: "Personal")
    ]
}
