//
//  ServersCoordinator.swift
//  EOS
//
//  Created DKM on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

protocol ServersCoordinatorProtocol {
}

protocol ServersStateManagerProtocol {
    var state: ServersState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<ServersState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState
}

class ServersCoordinator: NavCoordinator {
    
    lazy var creator = ServersPropertyActionCreate()
    
    var store = Store<ServersState>(
        reducer: ServersReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
}

extension ServersCoordinator: ServersCoordinatorProtocol {
    
}

extension ServersCoordinator: ServersStateManagerProtocol {
    var state: ServersState {
        return store.state
    }
    
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<ServersState>) -> Subscription<SelectedState>)?
        ) where S.StoreSubscriberStateType == SelectedState {
        store.subscribe(subscriber, transform: transform)
    }
    
}
