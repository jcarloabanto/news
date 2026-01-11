//
//  SourcesSelectionStore.swift
//  news
//
//  Created by James Abanto on 1/11/26.
//

import SwiftUI
import Combine

@MainActor
protocol SourcesSelectionStoreProtocol {
    
    /// A set of unique identifiers for the currently selected news sources.
    var selectedIDs: Set<String> { get set }
    
    /// Toggles the selection status of a specific news source.
    ///
    /// If the provided `sourceID` is already in ``selectedIDs``, it will be removed.
    /// If it is not present, it will be added.
    ///
    /// - Parameter sourceID: The unique string identifier of the news source
    ///   to be toggled (e.g., "bbc-news").
    func toggleSourceSelection(for sourceID: String)
}

final class SourcesSelectionStore: ObservableObject, SourcesSelectionStoreProtocol {
    
    enum Constants {
        static let selectedSourceIDKey: String = "selected_source_ids"
    }
    
    static let shared = SourcesSelectionStore()
    
    @Published
    var selectedIDs: Set<String> = []
    
    @AppStorage(Constants.selectedSourceIDKey)
    private var savedData: Data = Data()
    
    private init() {
        load()
    }
    
    func toggleSourceSelection(for sourceID: String) {
        if selectedIDs.contains(sourceID) {
            selectedIDs.remove(sourceID)
        } else {
            selectedIDs.insert(sourceID)
        }
        save()
    }
    
    private func save() {
        if let encoded = try? JSONEncoder().encode(selectedIDs) {
            savedData = encoded
        }
    }

    private func load() {
        if let decoded = try? JSONDecoder().decode(Set<String>.self, from: savedData) {
            selectedIDs = decoded
        }
    }
}
