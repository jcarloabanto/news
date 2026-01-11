//
//  MockSourceService.swift
//  newsTests
//
//  Created by James Abanto on 1/11/26.
//

import Foundation
@testable import news

class MockSourceService: NewsSourceServiceable {
    var result: Result<[NewsSource], Error> = .success([])
    
    func getSources() async throws -> [NewsSource] {
        switch result {
        case .success(let sources): return sources
        case .failure(let error): throw error
        }
    }
}
