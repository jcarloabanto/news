//
//  SourceViewModelTests.swift
//  newsTests
//
//  Created by James Abanto on 1/11/26.
//

import XCTest
import Combine
@testable import news

@MainActor
final class SourceViewModelTests: XCTestCase {
    var sut: SourceViewModel!
    var mockService: MockSourceService!
    var mockStore: MockSelectionStore!

    override func setUp() {
        super.setUp()
        mockService = MockSourceService()
        mockStore = MockSelectionStore()
        sut = SourceViewModel(sourceService: mockService, sourcesSelectionStore: mockStore)
    }

    override func tearDown() {
        sut = nil
        mockService = nil
        mockStore = nil
        super.tearDown()
    }

    func test_fetchSources_onSuccess_setsLoadedState() async {
        let mockSources = [NewsSource(id: "abc", name: "ABC News", description: "Test", language: "en")]
        mockService.result = .success(mockSources)

        await sut.fetchSources()

        if case .loaded(let sources) = sut.viewState {
            XCTAssertEqual(sources.count, 1)
            XCTAssertEqual(sources.first?.id, "abc")
        } else {
            XCTFail("Expected .loaded state, got \(sut.viewState)")
        }
    }

    func test_fetchSources_onEmpty_setsEmptyState() async {
        mockService.result = .success([])

        await sut.fetchSources()

        if case .empty = sut.viewState {
            XCTAssertTrue(true)
        } else {
            XCTFail("Expected .empty state")
        }
    }

    func test_fetchSources_onFailure_setsErrorState() async {
        let error = NSError(domain: "test", code: 404, userInfo: [NSLocalizedDescriptionKey: "Not Found"])
        mockService.result = .failure(error)

        await sut.fetchSources()

        if case .error(let message) = sut.viewState {
            XCTAssertTrue(message.contains("Not Found"))
        } else {
            XCTFail("Expected .error state")
        }
    }

    // MARK: - Interaction Tests

    func test_toggleSource_callsStoreAndNotifies() {
        let testID = "bbc-news"
 
        sut.toggleSource(testID)
        
        XCTAssertEqual(mockStore.toggleCalledWithID, testID, "Store toggle method should be called with correct ID")
        XCTAssertTrue(mockStore.selectedIDs.contains(testID))
    }
    
    func test_toggleSource_emitsObjectWillChange() {
        let expectation = XCTestExpectation(description: "Object will change should fire")
        
        let cancellable = sut.objectWillChange.sink { _ in
            expectation.fulfill()
        }
        
        sut.toggleSource("any-id")
        
        wait(for: [expectation], timeout: 1.0)
        cancellable.cancel()
    }
}
