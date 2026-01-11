//
//  NewsSource.swift
//  news
//
//  Created by James Abanto on 1/11/26.
//

import Foundation

struct NewsSource: Codable, Identifiable {
    let id: String
    let name: String
    let description: String
    let language: String
}
