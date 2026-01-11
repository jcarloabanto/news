//
//  Article.swift
//  news
//
//  Created by James Abanto on 1/11/26.
//

import Foundation

struct Article: Codable, Identifiable {
    /*
     Use URL as the id of the model
     */
    var id: String { url }
    let title: String
    let description: String?
    let author: String?
    let url: String
    let urlToImage: String?
}
