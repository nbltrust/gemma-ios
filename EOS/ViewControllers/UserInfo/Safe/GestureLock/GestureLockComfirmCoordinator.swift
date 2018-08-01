//
//  GestureLockComfirmCoordinator.swift
//  EOS
//
//  Created peng zhu on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

protocol GestureLockComfirmCoordinatorProtocol {
}

protocol GestureLockComfirmStateManagerProtocol {
    var state: GestureLockComfirmState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<GestureLockComfirmState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState
}

class GestureLockComfirmCoordinator: NavCoordinator {
    
    lazy var creator = GestureLockComfirmPropertyActionCreate()
    
    var store = Store<GestureLockComfirmState>(
        reducer: GestureLockComfirmReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
}

extension GestureLockComfirmCoordinator: GestureLockComfirmCoordinatorProtocol {
    
}

extension GestureLockComfirmCoordinator: GestureLockComfirmStateManagerProtocol {
    var state: GestureLockComfirmState {
        return store.state
    }
    
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<GestureLockComfirmState>) -> Subscription<SelectedState>)?
        ) where S.StoreSubscriberStateType == SelectedState {
        store.subscribe(subscriber, transform: transform)
    }
    
}
