//
//  GestureLockSetCoordinator.swift
//  EOS
//
//  Created peng zhu on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

protocol GestureLockSetCoordinatorProtocol {
}

protocol GestureLockSetStateManagerProtocol {
    var state: GestureLockSetState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<GestureLockSetState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState
}

class GestureLockSetCoordinator: GestureLockRootCoordinator {
    
    lazy var creator = GestureLockSetPropertyActionCreate()
    
    var store = Store<GestureLockSetState>(
        reducer: GestureLockSetReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
}

extension GestureLockSetCoordinator: GestureLockSetCoordinatorProtocol {
    
}

extension GestureLockSetCoordinator: GestureLockSetStateManagerProtocol {
    var state: GestureLockSetState {
        return store.state
    }
    
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<GestureLockSetState>) -> Subscription<SelectedState>)?
        ) where S.StoreSubscriberStateType == SelectedState {
        store.subscribe(subscriber, transform: transform)
    }
    
}
