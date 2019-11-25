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
    
    private let model: RepositoryModelProtocol
    private let disposeBag = DisposeBag()
    
    var repositories: [Repository] {
        return _repositories.value
    }
    
    private var _repositories = BehaviorRelay<[Repository]>(value: [])
    
    let reloadData: Observable<Void>
    let showSafariView: Observable<URL>
    
    init(searchBarText: Observable<String?>,
         searchButtonClicked: Observable<Void>,
         itemSelected: Observable<IndexPath>,
         model: RepositoryModelProtocol = RepositoryModel()) {
        
        self.model = model
        
        self.reloadData = _repositories.map { _ in }
        self.showSafariView = itemSelected.withLatestFrom(_repositories) { ($0, $1) }.flatMap { indexPath, repositories -> Observable<URL> in
            guard indexPath.row < repositories.count else {
                return .empty()
            }
            return .just(repositories[indexPath.row].url)
        }
        
        let searchResult = searchButtonClicked.withLatestFrom(searchBarText).flatMapFirst { [weak self] text -> Observable<Event<[Repository]>> in
            guard let me = self, let query = text else {
                return .empty()
            }
            return me.model.fetchRepositories(query).materialize()
        }.share()
        
        searchResult.flatMap { event -> Observable<[Repository]> in
            event.element.map(Observable.just) ?? .empty()
        }
        .bind(to: _repositories)
        .disposed(by: disposeBag)
        
        searchResult.flatMap { event -> Observable<Error> in
            event.error.map(Observable.just) ?? .empty()
        }
        .subscribe(onNext: { error in
            
        }).disposed(by: disposeBag)
    }
    
}
