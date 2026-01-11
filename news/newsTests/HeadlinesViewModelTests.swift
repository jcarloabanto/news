//
//  HeadlinesViewModelTest.swift
//  newsTests
//
//  Created by James Abanto on 1/11/26.
//

import XCTest
import Foundation
import SwiftData
@testable import news
@MainActor
final class HeadlinesViewModelTest: XCTestCase {

    var sut: HeadlinesViewModel!
    var mockService: MockArticleService!
    var mockStore: MockSelectionStore!

    override func setUp() {
        super.setUp()
        mockService = MockArticleService()
        mockStore = MockSelectionStore()
        sut = HeadlinesViewModel(articleService: mockService, sourcesSelectionStore: mockStore)
    }

    override func tearDown() {
        sut = nil
        mockService = nil
        mockStore = nil
        super.tearDown()
    }

    func test_loadHeadlines_withNoSources_setsStateToEmpty() async {
        mockStore.selectedIDs = []
        await sut.loadHeadlines()

        if case .empty = sut.viewState {
            XCTAssertTrue(true)
        } else {
            XCTFail("Expected .empty state, got \(sut.viewState)")
        }
    }

    func test_loadHeadlines_withSources_setsStateToLoaded() async {
        mockStore.selectedIDs = ["bbc-news"]
        let mockArticles = [Article(title: "Test", description: "Desc", author: "AI", url: "url", urlToImage: nil)]
        mockService.result = .success(mockArticles)

        await sut.loadHeadlines()

        if case .loaded(let articles) = sut.viewState {
            XCTAssertEqual(articles.count, 1)
            XCTAssertEqual(articles.first?.title, "Test")
        } else {
            XCTFail("Expected .loaded state, got \(sut.viewState)")
        }
    }

    func test_loadHeadlines_onServiceError_setsStateToError() async {
        mockStore.selectedIDs = ["cnn"]
        let error = NSError(domain: "test", code: 0, userInfo: [NSLocalizedDescriptionKey: "No Internet"])
        mockService.result = .failure(error)

        await sut.loadHeadlines()

        if case .error(let message) = sut.viewState {
            XCTAssertTrue(message.contains("No Internet"))
        } else {
            XCTFail("Expected .error state, got \(sut.viewState)")
        }
    }
    
    func test_saveArticle_addsToModelContext() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: SavedArticle.self, configurations: config)
        let context = container.mainContext
        
        let article = Article(title: "Save Me", description: nil, author: nil, url: "test-url", urlToImage: nil)

        sut.saveArticle(article, context: context)
        
        let descriptor = FetchDescriptor<SavedArticle>()
        let savedItems = try context.fetch(descriptor)
        
        XCTAssertEqual(savedItems.count, 1)
        XCTAssertEqual(savedItems.first?.url, "test-url")
    }
}
