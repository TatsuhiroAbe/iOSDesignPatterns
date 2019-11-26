//
//  RepositoryStore.swift
//  iOSDesignPatterns
//
//  Created by 阿部竜大 on 2019/11/26.
//  Copyright © 2019 阿部竜大. All rights reserved.
//

import Foundation

typealias Subscription = NSObjectProtocol

enum NotificationName {
    static let storeChanged = Notification.Name("store-changed")
}

final class RepositoryStore {
    
    static let shared = RepositoryStore()
    
    private(set) var repositories: [Repository] = []
    private(set) var query: String?
    private(set) var error: Error?
    
    private lazy var dispatchToken: String = {
        return dispatcher.register(callback: { [weak self] action in
            self?.onDispatch(action)
        })
    }()
    
    private let dispatcher: RepositoryDispatcher
    private let notificationCenter: NotificationCenter

    deinit {
        dispatcher.unregister(dispatchToken)
    }
    
    init(dispatcher: RepositoryDispatcher = .shared) {
        self.dispatcher = dispatcher
        self.notificationCenter = NotificationCenter()
        _ = dispatchToken
    }
    
    func onDispatch(_ action: RepositoryAction) {
        switch action {
        case let .fetchRepositories(repositories):
            self.repositories.append(contentsOf: repositories)
        case .clearRepositories:
            self.repositories.removeAll()
        case let .error(error):
            self.error = error
        }
        emitChange()
    }
    
    func emitChange() {
        notificationCenter.post(name: NotificationName.storeChanged, object: nil)
    }
    
    func addListener(callback: @escaping () -> ()) -> Subscription {
        let using: (Notification) -> () = { notification in
            if notification.name == NotificationName.storeChanged {
                callback()
            }
        }
        return notificationCenter.addObserver(forName: NotificationName.storeChanged,
                                              object: nil,
                                              queue: nil,
                                              using: using)
    }
    
    func removeListener(_ subscription: Subscription) {
        notificationCenter.removeObserver(subscription)
    }
}
