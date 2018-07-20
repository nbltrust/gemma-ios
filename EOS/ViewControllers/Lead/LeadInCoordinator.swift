//
//  LeadInCoordinator.swift
//  EOS
//
//  Created DKM on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

protocol LeadInCoordinatorProtocol {
}

protocol LeadInStateManagerProtocol {
    var state: LeadInState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<LeadInState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState
}

class LeadInCoordinator: HomeRootCoordinator {
    
    lazy var creator = LeadInPropertyActionCreate()
    
    var store = Store<LeadInState>(
        reducer: LeadInReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
}

extension LeadInCoordinator: LeadInCoordinatorProtocol {
    
}

extension LeadInCoordinator: LeadInStateManagerProtocol {
    var state: LeadInState {
        return store.state
    }
    
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<LeadInState>) -> Subscription<SelectedState>)?
        ) where S.StoreSubscriberStateType == SelectedState {
        store.subscribe(subscriber, transform: transform)
    }
    
}