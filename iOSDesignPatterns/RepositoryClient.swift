//
//  RepositoryClient.swift
//  iOSDesignPatterns
//
//  Created by 阿部竜大 on 2019/11/25.
//  Copyright © 2019 阿部竜大. All rights reserved.
//

import Foundation

enum Result<T, Error> {
    case success(T)
    case failure(Error)
}

class RepositoryClient {
    
    static let shared = RepositoryClient()
    
    let BASE_URL = "https://api.github.com/search/repositories?q="
    
    func fetchRepositories(_ query: String, completion: @escaping (Result<[Repository], Error>) -> Void){
        let url = URL(string: self.BASE_URL + query)!
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
