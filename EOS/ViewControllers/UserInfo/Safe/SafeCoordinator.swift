//
//  SafeCoordinator.swift
//  EOS
//
//  Created DKM on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

protocol SafeCoordinatorProtocol {
}

protocol SafeStateManagerProtocol {
    var state: SafeState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<SafeState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState
}

class SafeCoordinator: UserInfoRootCoordinator {
    
    lazy var creator = SafePropertyActionCreate()
    
    var store = Store<SafeState>(
        reducer: SafeReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
}

extension SafeCoordinator: SafeCoordinatorProtocol {
    
}

extension SafeCoordinator: SafeStateManagerProtocol {
    var state: SafeState {
        return store.state
    }
    
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<SafeState>) -> Subscription<SelectedState>)?
        ) where S.StoreSubscriberStateType == SelectedState {
        store.subscribe(subscriber, transform: transform)
    }
    
}
