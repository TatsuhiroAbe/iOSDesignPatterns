//
//  RepositoryViewController.swift
//  iOSDesignPatterns
//
//  Created by 阿部竜大 on 2019/11/26.
//  Copyright © 2019 阿部竜大. All rights reserved.
//

import UIKit

class RepositoryViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private let repositoryStore: RepositoryStore
    private let actionCreator: RepositoryActionCreator
    
    private lazy var reloadSubscription: Subscription = {
        return repositoryStore.addListener { [weak self] in
            self?.tableView.reloadData()
        }
    }()
    
    deinit {
        repositoryStore.removeListener(reloadSubscription)
    }
    
    init(repositoryStore: RepositoryStore = .shared,
         actionCreator: RepositoryActionCreator = .init()) {
        self.repositoryStore = repositoryStore
        self.actionCreator = actionCreator
        super.init(nibName: "RepositoryViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "RepositoryCell", bundle: nil), forCellReuseIdentifier: "RepositoryCell")

        _ = reloadSubscription
    }
}

extension RepositoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension RepositoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositoryStore.repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryCell", for: indexPath) as? RepositoryCell {
            let repository = repositoryStore.repositories[indexPath.row]
            cell.configure(repository)
            
            return cell
        }
        return UITableViewCell()
    }
}

extension RepositoryViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text, !text.isEmpty {
            actionCreator.clearRepositories()
            actionCreator.fetchRepositories(text)
        }
    }
}
