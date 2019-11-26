//
//  RepositoryActionCreator.swift
//  iOSDesignPatterns
//
//  Created by 阿部竜大 on 2019/11/26.
//  Copyright © 2019 阿部竜大. All rights reserved.
//

import Foundation

final class RepositoryActionCreator {
    
    private let dispatcher: RepositoryDispatcher
    private let apiClient: RepositoryAPIClinetProtocol
    
    init(dispatcher: RepositoryDispatcher = .shared,
         apiClient: RepositoryAPIClinetProtocol = RepositoryAPIClient.shared) {
        self.dispatcher = dispatcher
        self.apiClient = apiClient
    }
    
    func fetchRepositories(_ query: String) {
        apiClient.fetchRepositores(query) { [dispatcher] result in
            switch result {
            case let .success(repositories):
                dispatcher.dispatch(.fetchRepositories(repositories))
            case let .failure(error):
                dispatcher.dispatch(.error(error))
            }
        }
    }
    
    func clearRepositories() {
        dispatcher.dispatch(.clearRepositories)
    }
    
}
