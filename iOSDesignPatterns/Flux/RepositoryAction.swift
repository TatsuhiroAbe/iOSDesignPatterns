//
//  RepositoryAction.swift
//  iOSDesignPatterns
//
//  Created by 阿部竜大 on 2019/11/26.
//  Copyright © 2019 阿部竜大. All rights reserved.
//

import Foundation

enum RepositoryAction {
    case fetchRepositories([Repository])
    case clearRepositories
    case error(Error?)
}
