//
//  CreatationCompleteCoordinator.swift
//  EOS
//
//  Created peng zhu on 2018/7/12.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

protocol CreatationCompleteCoordinatorProtocol {
}

protocol CreatationCompleteStateManagerProtocol {
    var state: CreatationCompleteState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<CreatationCompleteState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState
}

class CreatationCompleteCoordinator: EntryRootCoordinator {
    
    lazy var creator = CreatationCompletePropertyActionCreate()
    
    var store = Store<CreatationCompleteState>(
        reducer: CreatationCompleteReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
}

extension CreatationCompleteCoordinator: CreatationCompleteCoordinatorProtocol {
    
}

extension CreatationCompleteCoordinator: CreatationCompleteStateManagerProtocol {
    var state: CreatationCompleteState {
        return store.state
    }
    
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<CreatationCompleteState>) -> Subscription<SelectedState>)?
        ) where S.StoreSubscriberStateType == SelectedState {
        store.subscribe(subscriber, transform: transform)
    }
    
}
