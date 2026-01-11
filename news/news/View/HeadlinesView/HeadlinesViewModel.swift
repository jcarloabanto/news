//
//  HeadlinesViewModel.swift
//  news
//
//  Created by James Abanto on 1/11/26.
//

import Foundation
import Combine
import SwiftData

@MainActor
class HeadlinesViewModel: ObservableObject {
    @Published var viewState: ViewState<[Article]> = .loading
    
    var selectedSources: [String] {
        Array(sourcesSelectionStore.selectedIDs)
    }
    
    private let articleService: NewsArticleServiceable
    private let sourcesSelectionStore: SourcesSelectionStoreProtocol
    
    init(articleService: NewsArticleServiceable,
         sourcesSelectionStore: SourcesSelectionStoreProtocol) {
        self.articleService = articleService
        self.sourcesSelectionStore = sourcesSelectionStore
    }
    
    func loadHeadlines() async {
        viewState = .loading
        guard !selectedSources.isEmpty else {
            viewState = .empty
            return
        }
        
        do {
            let articles = try await articleService.getHeadlines(for: selectedSources)
            viewState = .loaded(articles)
        } catch is CancellationError { // Don't change the view state when the task is cancelled, in an ideal scenario I would implement a debouncer
        } catch let error as URLError where error.code == .cancelled {
        } catch {
            viewState = .error("Failed to load news: \(error.localizedDescription)")
        }
    }
    
    func saveArticle(_ article: Article, context: ModelContext) {
        let newItem = SavedArticle(article: article)
        context.insert(newItem)
    }
}
