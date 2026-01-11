//
//  SourceSelectionStoreTests.swift
//  newsTests
//
//  Created by James Abanto on 1/11/26.
//

import XCTest
@testable import news

@MainActor
final class SourcesSelectionStoreTests: XCTestCase {
    var sut: SourcesSelectionStore!
    let testKey = SourcesSelectionStore.Constants.selectedSourceIDKey

    override func setUp() {
        super.setUp()
        // 1. Clear UserDefaults before each test to ensure a clean slate
        UserDefaults.standard.removeObject(forKey: testKey)
        
        // 2. Since it's a singleton, we reset the internal state
        sut = SourcesSelectionStore.shared
        sut.selectedIDs = []
    }

    override func tearDown() {
        // 3. Clean up after the test
        UserDefaults.standard.removeObject(forKey: testKey)
        sut = nil
        super.tearDown()
    }

    func test_toggleSourceSelection_addsID_whenNotPresent() {
        let id = "bbc-news"

        sut.toggleSourceSelection(for: id)

        XCTAssertTrue(sut.selectedIDs.contains(id))
        XCTAssertEqual(sut.selectedIDs.count, 1)
    }

    func test_toggleSourceSelection_removesID_whenPresent() {
        let id = "cnn"
        sut.toggleSourceSelection(for: id) // Add it first
        XCTAssertTrue(sut.selectedIDs.contains(id))
        XCTAssertEqual(sut.selectedIDs.count, 1)
        
        sut.toggleSourceSelection(for: id) // Toggle again to remove

        // Assert
        XCTAssertFalse(sut.selectedIDs.contains(id))
        XCTAssertEqual(sut.selectedIDs.count, 0)
    }

    func test_save_correctlyEncodesDataToUserDefaults() {
        let ids: Set<String> = ["techcrunch", "the-verge"]
        ids.forEach { sut.toggleSourceSelection(for: $0) }

        // Verify that the @AppStorage/UserDefaults actually contains the encoded data
        let savedData = UserDefaults.standard.data(forKey: testKey)
        XCTAssertNotNil(savedData)
        
        let decoded = try? JSONDecoder().decode(Set<String>.self, from: savedData!)
        XCTAssertEqual(decoded, ids)
    }
}
