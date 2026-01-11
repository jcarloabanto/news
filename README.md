🧩 Modular MVVM

Each view is backed by a ViewModel that communicates with services through Protocols. This decoupling allows for easy unit testing and swapping of implementations.

🔄 Generic View State

Utilised a generic ViewState<T> enum to manage the UI lifecycle. This ensures "impossible states" are avoided and UI consistency is maintained.

enum ViewState<T> {
    case loading
    case loaded(T)
    case empty
    case error(String)
}

💾 Persistence Layer

SwiftData: Used for high-performance persistence of SavedArticle objects, utilizing @Attribute(.unique) to prevent duplicate stories.

Selection Store: A protocol-oriented store for user preferences, backed by @AppStorage for lightweight persistence of selected source IDs.

🌐 Networking

A protocol-based REST API Client handles asynchronous data fetching. It includes:

Generic JSON decoding.

Safe URL construction using URLComponents.

🧪 Testing

Comprehensive suite of Unit Tests focusing on:

ViewModel Logic: Verifying state transitions and dependency interactions using Mocks.

Persistence: Ensuring SourcesSelectionStore correctly serializes data to UserDefaults.

Data Integrity: Validating SwiftData's uniqueness constraints and mapping logic.
