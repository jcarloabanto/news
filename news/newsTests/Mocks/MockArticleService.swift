//
//  MockArticleService.swift
//  newsTests
//
//  Created by James Abanto on 1/11/26.
//

import Foundation
@testable import news

class MockArticleService: NewsArticleServiceable {
    var result: Result<[Article], Error> = .success([])
    
    func getHeadlines(for sources: [String]) async throws -> [Article] {
        switch result {
        case .success(let articles): return articles
        case .failure(let error): throw error
        }
    }
}
