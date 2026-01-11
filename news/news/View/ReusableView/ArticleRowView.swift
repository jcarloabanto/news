//
//  ArticleRowView.swift
//  news
//
//  Created by James Abanto on 1/11/26.
//

import SwiftUI
import Kingfisher

/*
 Decided to use Kingfisher for image fetching
 as it can handle background downloading, disk caching, transitions, etc.
 out of the box
 */
struct ArticleRowView: View {
    let article: Article
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            KFImage(URL(string: article.urlToImage ?? ""))
                .placeholder {
                    // Shown while downloading or if URL is nil
                    Rectangle()
                        .foregroundColor(.gray.opacity(0.2))
                        .overlay(ProgressView())
                }
                .retry(maxCount: 3, interval: .seconds(5)) // Automatically retries failed downloads
                .resizable()
                .fade(duration: 0.25) // Smooth transition when image appears
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80)
                .clipped()
                .cornerRadius(8)
            
            // Text Content
            VStack(alignment: .leading, spacing: 4) {
                Text(article.title)
                    .font(.headline)
                    .lineLimit(2)
                
                Text(article.description ?? "")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                
                if let author = article.author {
                    Text("By \(author)")
                        .font(.caption2)
                        .italic()
                }
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    ArticleRowView(article: .init(title: "Sample Article",
                                  description: nil,
                                  author: nil,
                                  url: "www.facebook.com",
                                  urlToImage: ""))
}
