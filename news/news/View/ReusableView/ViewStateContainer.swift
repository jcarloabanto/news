//
//  ViewStateContainer.swift
//  news
//
//  Created by James Abanto on 1/11/26.
//

import SwiftUI

enum ViewState<T> {
    case loading
    case loaded(T)
    case empty
    case error(String)
}

/*
 Built a custom view to handle different states for views making an api call
 Could have made it more customisable but for the purposes of this exercise
 this will do for now.
 */
struct StateContainerView<T, Content: View>: View {
    let state: ViewState<T>
    let content: (T) -> Content

    var body: some View {
        Group {
            switch state {
            case .loading:
                ProgressView()
            case .empty:
                ContentUnavailableView("No Data", systemImage: "tray", description: Text("Nothing found."))
            case .error(let message):
                ContentUnavailableView("Error", systemImage: "exclamationmark.triangle", description: Text(message))
            case .loaded(let data):
                content(data)
            }
        }
    }
}
