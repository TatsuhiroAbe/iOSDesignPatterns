//
//  RepositoryViewModel.swift
//  iOSDesignPatterns
//
//  Created by 阿部竜大 on 2019/11/25.
//  Copyright © 2019 阿部竜大. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class RepositoryViewModel {
    
    private let model: RepositoryModel
    private let disposeBag = DisposeBag()
    
    let repositories: Observable<[Repository]>
    let error: Observable<Error>
    let deselectRow: Observable<IndexPath>
    let openURL: Observable<URL>
    
    init(searchBarText: Observable<String?>,
         searchButtonClicked: Observable<Void>,
         itemSelected: Observable<IndexPath>,
         model: RepositoryModel = RepositoryModel()) {
        
        self.model = model
        
        let searchResult = searchButtonClicked
            .withLatestFrom(searchBarText)
            .flatMapFirst { text -> Observable<Event<[Repository]>> in
                guard let query = text else {
                    return .empty()
                }
                return model.fetchRepositories(query).materialize()
            }
            .share()
        
        repositories = searchResult
            .flatMap { $0.element.map(Observable.just) ?? .empty() }
        
        error = searchResult
            .flatMap { $0.error.map(Observable.just) ?? .empty() }
        
        deselectRow = itemSelected.map { $0 }
        
        openURL = itemSelected
            .withLatestFrom(repositories) { ($0, $1) }
            .flatMap { indexPath, repositories -> Observable<URL> in
                guard indexPath.row < repositories.count else {
                    return .empty()
                }
                return .just(repositories[indexPath.row].url)
            }
    }
    
}
