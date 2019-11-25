//
//  RepositoryModel.swift
//  iOSDesignPatterns
//
//  Created by 阿部竜大 on 2019/11/25.
//  Copyright © 2019 阿部竜大. All rights reserved.
//

import Foundation

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


class RepositoryModel {
    
    let BASE_URL = "https://api.github.com/search/repositories?q="
    
    func fetchRepositories(_ query: String, completion: @escaping (Result<[Repository], Error>) -> ()) {
//        let url = URL(string: BASE_URL + query)!
//        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//            guard let data = data else { return }
//            if let error = error {
//                print("error: \(error.localizedDescription)")
//                return
//            }
//
//            do {
//                let repositoriesList = try JSONDecoder().decode(RepositoriesList.self, from: data)
//                completion(.success(repositoriesList.repositories))
//            } catch let err {
//                completion(.failure(err))
//            }
//
//        }
//        task.resume()
        
        var repositories: [Repository] = []
        for i in 0..<10 {
            let repository = Repository(
                name: "repo_\(i)",
                description: "description_\(i)",
                url: URL(string: "https://github.com/TatsuhiroAbe")!,
                language: "swift"
            )
            repositories.append(repository)
        }
        completion(.success(repositories))
    }
}
