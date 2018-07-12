//
//  EntryGuideCoordinator.swift
//  EOS
//
//  Created peng zhu on 2018/7/12.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

protocol EntryGuideCoordinatorProtocol {
}

protocol EntryGuideStateManagerProtocol {
    var state: EntryGuideState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<EntryGuideState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState
    
    func createNewWallet()
    func recoverFromCopy()
}

class EntryGuideCoordinator: EntryRootCoordinator {
    
    lazy var creator = EntryGuidePropertyActionCreate()
    
    var store = Store<EntryGuideState>(
        reducer: EntryGuideReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
}

extension EntryGuideCoordinator: EntryGuideCoordinatorProtocol {
    
}

extension EntryGuideCoordinator: EntryGuideStateManagerProtocol {
    var state: EntryGuideState {
        return store.state
    }
    
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<EntryGuideState>) -> Subscription<SelectedState>)?
        ) where S.StoreSubscriberStateType == SelectedState {
        store.subscribe(subscriber, transform: transform)
    }
    
    func createNewWallet() {
        
    }
    
    func recoverFromCopy() {
        
    }
}
