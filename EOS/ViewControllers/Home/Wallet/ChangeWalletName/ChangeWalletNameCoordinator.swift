//
//  ChangeWalletNameCoordinator.swift
//  EOS
//
//  Created zhusongyu on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

protocol ChangeWalletNameCoordinatorProtocol {
}

protocol ChangeWalletNameStateManagerProtocol {
    var state: ChangeWalletNameState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<ChangeWalletNameState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState
}

class ChangeWalletNameCoordinator: HomeRootCoordinator {
    
    lazy var creator = ChangeWalletNamePropertyActionCreate()
    
    var store = Store<ChangeWalletNameState>(
        reducer: ChangeWalletNameReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
}

extension ChangeWalletNameCoordinator: ChangeWalletNameCoordinatorProtocol {
    
}

extension ChangeWalletNameCoordinator: ChangeWalletNameStateManagerProtocol {
    var state: ChangeWalletNameState {
        return store.state
    }
    
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<ChangeWalletNameState>) -> Subscription<SelectedState>)?
        ) where S.StoreSubscriberStateType == SelectedState {
        store.subscribe(subscriber, transform: transform)
    }
    
}
