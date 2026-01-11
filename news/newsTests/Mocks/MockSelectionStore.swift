//
//  MockSelectionStore.swift
//  newsTests
//
//  Created by James Abanto on 1/11/26.
//

import Foundation
@testable import news

class MockSelectionStore: SourcesSelectionStoreProtocol {
    var selectedIDs: Set<String> = []
    var toggleCalledWithID: String?

        func toggleSourceSelection(for id: String) {
            toggleCalledWithID = id
            if selectedIDs.contains(id) {
                selectedIDs.remove(id)
            } else {
                selectedIDs.insert(id)
            }
        }
}
