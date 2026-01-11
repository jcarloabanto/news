//
//  SourcesView.swift
//  news
//
//  Created by James Abanto on 1/11/26.
//

import SwiftUI

struct SourcesView: View {
    @StateObject var viewModel = SourceViewModel(sourceService: NewsService.shared,
                                                 sourcesSelectionStore: SourcesSelectionStore.shared)

    var body: some View {
        NavigationStack {
            StateContainerView(state: viewModel.viewState) { sources in
                List(sources) { source in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(source.name).font(.headline)
                            Text(source.description).font(.caption).foregroundStyle(.secondary)
                        }
                        Spacer()
                        if viewModel.selectedIDs.contains(source.id) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.blue)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        viewModel.toggleSource(source.id)
                    }
                }
            }
            .navigationTitle("News Sources")
        }
        .task {
            await viewModel.fetchSources()
        }
    }
}

#Preview {
    SourcesView()
}
