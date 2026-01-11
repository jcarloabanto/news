//
//  SavedArticlesView.swift
//  news
//
//  Created by James Abanto on 1/11/26.
//

import SwiftUI
import SwiftData

struct SavedArticlesView: View {
    @Query(sort: \SavedArticle.savedAt, order: .reverse) var savedArticles: [SavedArticle]
    @Environment(\.modelContext) private var modelContext

        var body: some View {
            NavigationStack {
                List {
                    ForEach(savedArticles) { item in
                        NavigationLink(destination: WebView(urlString: item.url)) {
                            let article = Article(title: item.title,
                                                  description: item.desc,
                                                  author: item.author,
                                                  url: item.url,
                                                  urlToImage: item.urlToImage)
                            ArticleRowView(article: article)
                        }
                    }
                    .onDelete { indexes in
                        for index in indexes { modelContext.delete(savedArticles[index]) }
                    }
                }
                .navigationTitle("Saved")
                .overlay {
                    if savedArticles.isEmpty {
                        ContentUnavailableView("No Saved Articles", systemImage: "bookmark.slash")
                    }
                }
            }
        }
}

#Preview {
    SavedArticlesView()
}
