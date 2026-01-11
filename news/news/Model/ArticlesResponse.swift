//
//  ArticlesResponse.swift
//  news
//
//  Created by James Abanto on 1/11/26.
//

import Foundation

struct ArticlesResponse: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}
