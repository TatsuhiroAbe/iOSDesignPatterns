//
//  RepositoryPresenter.swift
//  iOSDesignPatterns
//
//  Created by 阿部竜大 on 2019/11/25.
//  Copyright © 2019 阿部竜大. All rights reserved.
//

import Foundation

protocol RepositoryPresenterInput: class {
    func repository(_ row: Int) -> Repository?
    func didSelectRow(at indexPath: IndexPath)
    func didTapSearchButton(with searchText: String?)
}

protocol RepositoryPresenterOutput: AnyObject {
    func updateRepositories(_ repositories: [Repository])
    func transitionToSafariView(_ url: URL)
}

class RepositoryPresenter: RepositoryPresenterInput {

    private(set) var repositories: [Repository] = []
    
    private weak var view: RepositoryPresenterOutput!
    private var model: RepositoryModelInput
    
    init(view: RepositoryPresenterOutput, model: RepositoryModelInput) {
        self.view = view
        self.model = model
    }

    func repository(_ row: Int) -> Repository? {
        guard row < repositories.count else { return nil }
        return repositories[row]
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        guard let repository = repository(indexPath.row) else { return }
        view.transitionToSafariView(repository.url)
    }
    
    func didTapSearchButton(with searchText: String?) {
        guard let searchText = searchText, !searchText.isEmpty else { return }
        model.fetchRepositories(searchText) { [weak self] result in
            switch result {
            case let .success(repositories):
                self?.repositories = repositories
                
                DispatchQueue.main.async {
                    self?.view.updateRepositories(repositories)
                }
            case let .failure(error):
                print(error)
            }
        }
    }
}

