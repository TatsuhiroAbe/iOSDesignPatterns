//
//  Repository.swift
//  iOSDesignPatterns
//
//  Created by 阿部竜大 on 2019/11/26.
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
