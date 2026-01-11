//
//  MainTabView.swift
//  news
//
//  Created by James Abanto on 1/11/26.
//

import SwiftUI
import SwiftData
struct MainTabView: View {
    @Query var savedArticles: [SavedArticle]
    var body: some View {
        TabView {
            HeadlinesView()
                .tabItem { Label("Headlines", systemImage: "newspaper") }
            
            SourcesView()
                .tabItem { Label("Sources", systemImage: "list.bullet") }
            
            SavedArticlesView()
                .tabItem { Label("Saved", systemImage: "bookmark.fill") }
                .badge(savedArticles.count)
        }
    }
}

#Preview {
    MainTabView()
}
