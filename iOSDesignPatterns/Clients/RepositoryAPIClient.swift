//
//  RepositoryClient.swift
//  iOSDesignPatterns
//
//  Created by 阿部竜大 on 2019/11/26.
//  Copyright © 2019 阿部竜大. All rights reserved.
//

import Foundation

protocol RepositoryAPIClinetProtocol {
    func fetchRepositores(_ query: String, completion: @escaping (Result<[Repository], Error>) -> ())
}

class RepositoryAPIClient: RepositoryAPIClinetProtocol {
    
    static let shared = RepositoryAPIClient()
    
    let BASE_URL = "https://api.github.com/search/repositories?q="
    
    func fetchRepositores(_ query: String, completion: @escaping (Result<[Repository], Error>) -> ()) {
        let url = URL(string: BASE_URL + query)!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            if let error = error {
                print("error: \(error.localizedDescription)")
                return
            }

            do {
                let repositoriesList = try JSONDecoder().decode(RepositoriesList.self, from: data)
                completion(.success(repositoriesList.repositories))
            } catch let err {
                completion(.failure(err))
            }

        }
        task.resume()
    }
    
}

class MockRepositoryAPIClinet: RepositoryAPIClinetProtocol {
    func fetchRepositores(_ query: String, completion: @escaping (Result<[Repository], Error>) -> ()) {
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
