//
//  HeadlinesView.swift
//  news
//
//  Created by James Abanto on 1/11/26.
//

import SwiftUI

struct HeadlinesView: View {
    @StateObject
    private var viewModel = HeadlinesViewModel(articleService: NewsService.shared,
                                               sourcesSelectionStore: SourcesSelectionStore.shared)
    
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationStack {
            StateContainerView(state: viewModel.viewState) { articles in
                List(articles) { article in
                    NavigationLink(destination: WebView(urlString: article.url)) {
                        ArticleRowView(article: article)
                            .swipeActions(edge: .trailing) {
                                Button {
                                    viewModel.saveArticle(article, context: modelContext)
                                } label: {
                                    Label("Save", systemImage: "bookmark")
                                }
                                .tint(.blue)
                            }
                    }
                }
                .refreshable {
                    await viewModel.loadHeadlines()
                }
            }
            .navigationTitle("Headlines")
            .task(id: viewModel.selectedSources) {
                await viewModel.loadHeadlines()
            }
        }
    }
}

#Preview {
    HeadlinesView()
}
