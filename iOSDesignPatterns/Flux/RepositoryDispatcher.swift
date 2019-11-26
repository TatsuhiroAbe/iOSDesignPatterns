//
//  RepositoryDispatcher.swift
//  iOSDesignPatterns
//
//  Created by 阿部竜大 on 2019/11/26.
//  Copyright © 2019 阿部竜大. All rights reserved.
//

import Foundation

final class RepositoryDispatcher {
    
    static let shared = RepositoryDispatcher()
    
    let lock: NSLocking
    private var callbacks: [String: (RepositoryAction) -> ()]
    
    init() {
        self.lock = NSRecursiveLock()
        self.callbacks = [:]
    }
    
    func register(callback: @escaping (RepositoryAction) -> ()) -> String {
        lock.lock(); defer { lock.unlock() }

        let token =  UUID().uuidString
        callbacks[token] = callback
        return token
    }

    func unregister(_ token: String) {
        lock.lock(); defer { lock.unlock() }

        callbacks.removeValue(forKey: token)
    }
    
    func dispatch(_ action: RepositoryAction) {
        lock.lock(); defer { lock.unlock() }
        
        callbacks.forEach { _, callback in
            callback(action)
        }
    }
}
