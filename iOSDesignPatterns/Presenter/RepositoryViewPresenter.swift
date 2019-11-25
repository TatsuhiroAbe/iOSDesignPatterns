//
//  RepositoryPresenter.swift
//  iOSDesignPatterns
//
//  Created by 阿部竜大 on 2019/11/25.
//  Copyright © 2019 阿部竜大. All rights reserved.
//

import Foundation

protocol RepositoryPresenter: class {
    var view: RepositoryView? { get set }
    var numberOfRepositories: Int { get }
    func repository(_ row: Int) -> Repository?
    func didSelectRow(at indexPath: IndexPath)
    func didTapSearchButton(with searchText: String?)
}

class RepositoryViewPresenter: RepositoryPresenter {
    
    weak var view: RepositoryView?
    
    private(set) var repositories: [Repository] = []
    
    private var model: RepositoryModel!
    
    init(model: RepositoryModel) {
        self.model = model
    }

    var numberOfRepositories: Int {
        return repositories.count
    }
    
    func repository(_ row: Int) -> Repository? {
        guard row < repositories.count else { return nil }
        return repositories[row]
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        guard let repository = repository(indexPath.row) else { return }
        view?.showSafariView(repository.url)
    }
    
    func didTapSearchButton(with searchText: String?) {
        guard let searchText = searchText, !searchText.isEmpty else { return }
        model.fetchRepositories(searchText) { [weak self] result in
            switch result {
            case let .success(repositories):
                self?.repositories = repositories
                
                DispatchQueue.main.async {
                    self?.view?.reloadData()
                }
            case let .failure(error):
                print(error)
            }
        }
    }
}

