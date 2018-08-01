//
//  GestureLockSetCoordinator.swift
//  EOS
//
//  Created peng zhu on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

enum GestureLockMode: Int {
    case set = 1
    case comfirm
    case update
}

protocol GestureLockSetCoordinatorProtocol {
    
}

protocol GestureLockSetStateManagerProtocol {
    var state: GestureLockSetState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<GestureLockSetState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState
}

class GestureLockSetCoordinator: NavCoordinator {
    
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
