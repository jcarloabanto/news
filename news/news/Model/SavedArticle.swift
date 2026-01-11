//
//  SavedArticle.swift
//  news
//
//  Created by James Abanto on 1/11/26.
//

import Foundation
import SwiftData

@Model
class SavedArticle {
    @Attribute(.unique) var url: String
    var title: String
    var desc: String
    var author: String?
    var urlToImage: String?
    var savedAt: Date
    
    init(article: Article) {
        self.url = article.url
        self.title = article.title
        self.desc = article.description ?? ""
        self.author = article.author
        self.urlToImage = article.urlToImage
        self.savedAt = Date()
    }
}
