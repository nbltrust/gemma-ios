//
//  UserInfoCoordinator.swift
//  EOS
//
//  Created koofrank on 2018/7/12.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

protocol UserInfoCoordinatorProtocol {
}

protocol UserInfoStateManagerProtocol {
    var state: UserInfoState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<UserInfoState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState
}

class UserInfoCoordinator: UserInfoRootCoordinator {
    
    lazy var creator = UserInfoPropertyActionCreate()
    
    var store = Store<UserInfoState>(
        reducer: UserInfoReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
}

extension UserInfoCoordinator: UserInfoCoordinatorProtocol {
    
}

extension UserInfoCoordinator: UserInfoStateManagerProtocol {
    var state: UserInfoState {
        return store.state
    }
    
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<UserInfoState>) -> Subscription<SelectedState>)?
        ) where S.StoreSubscriberStateType == SelectedState {
        store.subscribe(subscriber, transform: transform)
    }
    
}
