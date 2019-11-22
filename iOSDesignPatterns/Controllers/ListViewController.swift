//
//  ListViewController.swift
//  iOSDesignPatterns
//
//  Created by 阿部竜大 on 2019/11/22.
//  Copyright © 2019 阿部竜大. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let repositoryModel = RepositoryModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureSearchBar()
        configureTableView()
        
        repositoryModel.delegate = self
        
        repositoryModel.fetchRepositories("swift")
    }

    private func configureSearchBar() {
        searchBar.delegate = self
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "RepositoryCell", bundle: nil), forCellReuseIdentifier: "RepositoryCell")
        tableView.rowHeight = 100
    }
}

extension ListViewController: UISearchBarDelegate {
    
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositoryModel.repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryCell", for: indexPath) as? RepositoryCell {
            cell.configure(with: repositoryModel.repositories[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
}

extension ListViewController: RepositoryModelDelegate {
    func repositoryModel(_ repositoryModel: RepositoryModel, didChange repositories: [Repository]) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
