//
//  Result.swift
//  iOSDesignPatterns
//
//  Created by 阿部竜大 on 2019/11/25.
//  Copyright © 2019 阿部竜大. All rights reserved.
//

enum Result<T, Error> {
    case success(T)
    case failure(Error)
}
