//
//  RepositoryViewController.swift
//  iOSDesignPatterns
//
//  Created by 阿部竜大 on 2019/11/25.
//  Copyright © 2019 阿部竜大. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SafariServices

class RepositoryViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    
    init() {
        super.init(nibName: "RepositoryViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Repository"
        
        searchBar.delegate = self
        configureTableView()
        
        let viewModel = RepositoryViewModel(
            searchBarText: searchBar.rx.text.asObservable(),
            searchButtonClicked: searchBar.rx.searchButtonClicked.asObservable(),
            itemSelected: tableView.rx.itemSelected.asObservable(),
            model: RepositoryModel(client: MockRepositoryAPIClinet.shared)
        )
        
        viewModel.repositories
            .bind(to: tableView.rx.items(cellIdentifier: "RepositoryCell")) { (_, repository, cell: RepositoryCell) in
                cell.configure(repository)
            }
            .disposed(by: disposeBag)
        
        viewModel.deselectRow
            .bind(to: Binder(self) { me, indexPath in
                me.tableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.openURL
            .bind(to: Binder(self) { me, url in
                let safariViewController = SFSafariViewController(url: url)
                me.present(safariViewController, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
    private func configureTableView() {
        tableView.estimatedRowHeight = 64
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "RepositoryCell", bundle: nil), forCellReuseIdentifier: "RepositoryCell")
    }
    
}

extension RepositoryViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
}
