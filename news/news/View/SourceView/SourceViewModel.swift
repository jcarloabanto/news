//
//  SourceViewModel.swift
//  news
//
//  Created by James Abanto on 1/11/26.
//

import Foundation
import Combine
import SwiftUI

@MainActor
class SourceViewModel: ObservableObject {
    @Published var viewState: ViewState<[NewsSource]> = .loading
    
    var selectedIDs: Set<String> {
        sourcesSelectionStore.selectedIDs
    }

    private let sourceService: NewsSourceServiceable
    private let sourcesSelectionStore: SourcesSelectionStoreProtocol
    
    init(sourceService: NewsSourceServiceable,
         sourcesSelectionStore: SourcesSelectionStoreProtocol) {
        self.sourceService = sourceService
        self.sourcesSelectionStore = sourcesSelectionStore
    }
    
    func fetchSources() async {
        viewState = .loading
        do {
            let availableSources = try await sourceService.getSources()
            viewState = availableSources.isEmpty ? .empty : .loaded(availableSources)
        } catch {
            viewState = .error("Failed to fetch sources: \(error.localizedDescription)")
        }
    }
    
    func toggleSource(_ id: String) {
        sourcesSelectionStore.toggleSourceSelection(for: id)
        objectWillChange.send()
    }
}
