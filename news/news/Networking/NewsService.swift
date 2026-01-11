//
//  NewsService.swift
//  news
//
//  Created by James Abanto on 1/11/26.
//

import Foundation

protocol NewsArticleServiceable {
    /// Fetches the top headlines for a specific set of news sources.
    ///
    /// - Parameter sources: An array of unique identifiers (IDs) for the news sources
    /// - Returns: An array of `Article` objects representing the latest news.
    /// - Throws: A `NetworkError` if the request fails, the URL is invalid,
    ///   or decoding fails.
    func getHeadlines(for sources: [String]) async throws -> [Article]
}

protocol NewsSourceServiceable {
    /// Retrieves a comprehensive list of all news sources supported by the service.
    ///
    /// This method is typically used to populate the source selection screen,
    /// allowing users to filter headlines by specific outlets.
    ///
    /// - Returns: An array of `NewsSource` objects containing the ID, name,
    ///   and description of each outlet.
    /// - Throws: A `NetworkError` if the request fails, the URL is invalid,
    ///   or decoding fails.
    func getSources() async throws -> [NewsSource]
}

protocol NewsServiceProtocol: NewsArticleServiceable, NewsSourceServiceable {}

final class NewsService: NewsServiceProtocol, RESTAPIClientProtocol {
    
    var baseURL: String {
        "https://newsapi.org/v2"
    }
    
    var apiKey: String? {
        "60ee0e777e534186b3f0ac5e6fe9ceb7"
    }
    
    static let shared = NewsService()
    
    func getHeadlines(for sources: [String]) async throws -> [Article] {
        let sourceString = sources.joined(separator: ",")
        let query = [URLQueryItem(name: "sources", value: sourceString)]
        let response: ArticlesResponse = try await request(endpoint: "/top-headlines", queryItems: query)
        return response.articles
    }
    
    func getSources() async throws -> [NewsSource] {
        let query = [URLQueryItem(name: "language", value: "en")]
        let response: NewsSourceResponse = try await request(endpoint: "/top-headlines/sources", queryItems: query)
        return response.sources
    }
}
