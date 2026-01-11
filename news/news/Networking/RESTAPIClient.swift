//
//  APIClient.swift
//  news
//
//  Created by James Abanto on 1/11/26.
//

import Foundation

/**
 Handle all the generic error that is known for a basic api call
 */
enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError(Error)
    case serverError(Int)
}

protocol RESTAPIClientProtocol {
    /// The base URL string for the API service (e.g., "https://newsapi.org/v2").
    /// All endpoint requests will be appended to this string to form a complete URL.
    var baseURL: String { get }
    
    /// An optional API key used for authenticating requests.
    ///
    /// This key is typically included in the request headers or as a query parameter
    /// depending on the specific API requirements.
    var apiKey: String? { get }
    
    /// Performs an asynchronous network request and decodes the response into a
    /// specific Decodable type.
    ///
    /// - Parameters:
    ///   - endpoint: The specific path to be appended to the `baseURL` (e.g., "/top-headlines").
    ///   - queryItems: An array of `URLQueryItem` objects to be appended as query
    ///     parameters to the URL.
    /// - Returns: A decoded object of type `T`, conforming to the `Codable` protocol.
    /// - Throws: An error if the URL is malformed, the network request fails, or
    ///   the response data cannot be decoded into the expected type.
    func request<T: Codable>(endpoint: String, queryItems: [URLQueryItem]) async throws -> T
}

extension RESTAPIClientProtocol {
    func request<T: Codable>(endpoint: String, queryItems: [URLQueryItem] = []) async throws -> T {
        guard var components = URLComponents(string: baseURL + endpoint) else {
            throw NetworkError.invalidURL
        }
        
        var items = queryItems
        if let apiKey {
            items.append(URLQueryItem(name: "apiKey", value: apiKey))
        }
        
        components.queryItems = items
        
        guard let url = components.url else { throw NetworkError.invalidURL }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(httpResponse.statusCode)
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}
