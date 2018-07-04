//
//  HomeCoordinator.swift
//  EOS
//
//  Created koofrank on 2018/7/4.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

protocol HomeCoordinatorProtocol {
}

protocol HomeStateManagerProtocol {
    var state: HomeState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<HomeState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState
}

class HomeCoordinator: HomeRootCoordinator {
    
    lazy var creator = HomePropertyActionCreate()
    
    var store = Store<HomeState>(
        reducer: HomeReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
}

extension HomeCoordinator: HomeCoordinatorProtocol {
    
}

extension HomeCoordinator: HomeStateManagerProtocol {
    var state: HomeState {
        return store.state
    }
    
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<HomeState>) -> Subscription<SelectedState>)?
        ) where S.StoreSubscriberStateType == SelectedState {
        store.subscribe(subscriber, transform: transform)
    }
    
}
