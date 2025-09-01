//
//  NetworkManager.swift
//  Modern macOS App Template
//
//  Created by Developer on $(date).
//

import Foundation
import Combine

/// Network manager for handling API requests
@MainActor
class NetworkManager: ObservableObject {

    static let shared = NetworkManager()

    @Published var isLoading = false
    @Published var lastError: NetworkError?

    private let session: URLSession
    private var cancellables = Set<AnyCancellable>()

    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = AppConstants.Network.timeout
        config.timeoutIntervalForResource = AppConstants.Network.timeout * 2
        self.session = URLSession(configuration: config)
    }

    /// Generic method for performing network requests
    func request<T: Codable>(
        _ endpoint: NetworkEndpoint,
        responseType: T.Type
    ) async throws -> T {
        isLoading = true
        lastError = nil

        defer { isLoading = false }

        do {
            let request = try endpoint.urlRequest()
            let (data, response) = try await session.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.httpError(httpResponse.statusCode)
            }

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601

            return try decoder.decode(T.self, from: data)

        } catch {
            let networkError = error as? NetworkError ?? NetworkError.unknown(error)
            lastError = networkError
            throw networkError
        }
    }

    /// Download data from URL
    func downloadData(from url: URL) async throws -> Data {
        isLoading = true
        defer { isLoading = false }

        let (data, response) = try await session.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.downloadFailed
        }

        return data
    }

    /// Upload data to URL
    func uploadData(_ data: Data, to url: URL) async throws {
        isLoading = true
        defer { isLoading = false }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data

        let (_, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.uploadFailed
        }
    }
}

// MARK: - Network Endpoint
enum NetworkEndpoint {
    case getItems
    case getItem(id: String)
    case createItem(data: Data)
    case updateItem(id: String, data: Data)
    case deleteItem(id: String)

    var baseURL: String {
        return AppConstants.Network.baseURL
    }

    var path: String {
        switch self {
        case .getItems:
            return "/items"
        case .getItem(let id):
            return "/items/\(id)"
        case .createItem:
            return "/items"
        case .updateItem(let id, _):
            return "/items/\(id)"
        case .deleteItem(let id):
            return "/items/\(id)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getItems, .getItem:
            return .GET
        case .createItem:
            return .POST
        case .updateItem:
            return .PUT
        case .deleteItem:
            return .DELETE
        }
    }

    var headers: [String: String] {
        let headers = ["Content-Type": "application/json"]

        // Add authentication headers if needed
        // headers["Authorization"] = "Bearer \(authToken)"

        return headers
    }

    func urlRequest() throws -> URLRequest {
        guard let url = URL(string: baseURL + path) else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        switch self {
        case .createItem(let data), .updateItem(_, let data):
            request.httpBody = data
        default:
            break
        }

        return request
    }
}

// MARK: - HTTP Method
enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
    case PATCH = "PATCH"
}

// MARK: - Network Error
enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(Int)
    case decodingError
    case encodingError
    case downloadFailed
    case uploadFailed
    case noInternetConnection
    case timeout
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response"
        case .httpError(let code):
            return "HTTP error: \(code)"
        case .decodingError:
            return "Failed to decode response"
        case .encodingError:
            return "Failed to encode request"
        case .downloadFailed:
            return "Download failed"
        case .uploadFailed:
            return "Upload failed"
        case .noInternetConnection:
            return "No internet connection"
        case .timeout:
            return "Request timed out"
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}
