//
//  RepositoryModel.swift
//  iOSDesignPatterns
//
//  Created by 阿部竜大 on 2019/11/25.
//  Copyright © 2019 阿部竜大. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct RepositoriesList: Decodable {
    let repositories: [Repository]
    
    private enum CodingKeys: String, CodingKey {
        case repositories = "items"
    }
}

struct Repository: Decodable {
    let name: String
    let description: String
    let url: URL
    let language: String
    
    private enum CodingKeys: String, CodingKey {
        case name = "full_name"
        case description
        case url = "html_url"
        case language
    }
}

protocol RepositoryModelProtocol {
    func fetchRepositories(_ query: String) -> Observable<[Repository]>
}

class RepositoryModel: RepositoryModelProtocol {
    func fetchRepositories(_ query: String) -> Observable<[Repository]> {
        return Observable.create { observer in
            RepositoryAPIClient.shared.fetchRepositories(query) { result in
                switch result {
                case let . success(repositories):
                    observer.onNext(repositories)
                    observer.onCompleted()
                case let .failure(error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}
