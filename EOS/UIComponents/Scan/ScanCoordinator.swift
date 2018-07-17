//
//  ScanCoordinator.swift
//  EOS
//
//  Created peng zhu on 2018/7/16.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

protocol ScanCoordinatorProtocol {
}

protocol ScanStateManagerProtocol {
    var state: ScanState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<ScanState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState
}

class ScanCoordinator: <#RootCoordinator#> {
    
    lazy var creator = ScanPropertyActionCreate()
    
    var store = Store<ScanState>(
        reducer: ScanReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
}

extension ScanCoordinator: ScanCoordinatorProtocol {
    
}

extension ScanCoordinator: ScanStateManagerProtocol {
    var state: ScanState {
        return store.state
    }
    
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<ScanState>) -> Subscription<SelectedState>)?
        ) where S.StoreSubscriberStateType == SelectedState {
        store.subscribe(subscriber, transform: transform)
    }
    
}
