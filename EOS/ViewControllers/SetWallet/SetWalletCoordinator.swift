//
//  SetWalletCoordinator.swift
//  EOS
//
//  Created DKM on 2018/7/20.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

protocol SetWalletCoordinatorProtocol {
}

protocol SetWalletStateManagerProtocol {
    var state: SetWalletState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<SetWalletState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState
}

class SetWalletCoordinator: HomeRootCoordinator {
    
    lazy var creator = SetWalletPropertyActionCreate()
    
    var store = Store<SetWalletState>(
        reducer: SetWalletReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
}

extension SetWalletCoordinator: SetWalletCoordinatorProtocol {
    
}

extension SetWalletCoordinator: SetWalletStateManagerProtocol {
    var state: SetWalletState {
        return store.state
    }
    
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<SetWalletState>) -> Subscription<SelectedState>)?
        ) where S.StoreSubscriberStateType == SelectedState {
        store.subscribe(subscriber, transform: transform)
    }
    
}
