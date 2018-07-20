//
//  AboutCoordinator.swift
//  EOS
//
//  Created DKM on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

protocol AboutCoordinatorProtocol {
    
}

protocol AboutStateManagerProtocol {
    var state: AboutState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<AboutState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState
}

class AboutCoordinator: UserInfoRootCoordinator {
    
    lazy var creator = AboutPropertyActionCreate()
    
    var store = Store<AboutState>(
        reducer: AboutReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
}

extension AboutCoordinator: AboutCoordinatorProtocol {
    
}

extension AboutCoordinator: AboutStateManagerProtocol {
    var state: AboutState {
        return store.state
    }
    
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<AboutState>) -> Subscription<SelectedState>)?
        ) where S.StoreSubscriberStateType == SelectedState {
        store.subscribe(subscriber, transform: transform)
    }
    
}
