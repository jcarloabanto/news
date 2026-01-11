//
//  newsApp.swift
//  news
//
//  Created by James Abanto on 1/11/26.
//

import SwiftUI
import SwiftData

/**
 Decided to use SwiftData when saving the articles as it can be seamlessly
 integrated with SwiftUI.
 */
@main
struct newsApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(for: [SavedArticle.self])
    }
}
