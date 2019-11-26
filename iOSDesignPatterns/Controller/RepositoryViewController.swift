//
//  RepositoryViewController.swift
//  iOSDesignPatterns
//
//  Created by 阿部竜大 on 2019/11/26.
//  Copyright © 2019 阿部竜大. All rights reserved.
//

import UIKit
import SafariServices

class RepositoryViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let repositoryModel: RepositoryModel!
    
    init(repositoryModel: RepositoryModel = RepositoryModel()) {
        self.repositoryModel = repositoryModel
        super.init(nibName: String(describing: RepositoryViewController.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Repository"
        
        configureSearchBar()
        configureTableView()
        repositoryModel.delegate = self
    }

    private func configureSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Enter text"
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "RepositoryCell", bundle: nil), forCellReuseIdentifier: "RepositoryCell")
    }
}

extension RepositoryViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        
        if let searchText = searchBar.text, !searchText.isEmpty {
            repositoryModel.fetchRepositories(searchText)
        }
    }
}

extension RepositoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let url = repositoryModel.repositories[indexPath.row].url
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true, completion: nil)
    }
}

extension RepositoryViewController: UITableViewDataSource {
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

extension RepositoryViewController: RepositoryModelDelegate {
    func repositoryModel(_ repositoryModel: RepositoryModel, didChange repositories: [Repository]) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
