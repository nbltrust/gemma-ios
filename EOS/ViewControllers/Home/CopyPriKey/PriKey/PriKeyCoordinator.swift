//
//  PriKeyCoordinator.swift
//  EOS
//
//  Created peng zhu on 2018/8/1.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

protocol PriKeyCoordinatorProtocol {
}

protocol PriKeyStateManagerProtocol {
    var state: PriKeyState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<PriKeyState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState
}

class PriKeyCoordinator: NavCoordinator {

    lazy var creator = PriKeyPropertyActionCreate()

    var store = Store<PriKeyState>(
        reducer: PriKeyReducer,
        state: nil,
        middleware: [TrackingMiddleware]
    )
}

extension PriKeyCoordinator: PriKeyCoordinatorProtocol {

}

extension PriKeyCoordinator: PriKeyStateManagerProtocol {
    var state: PriKeyState {
        return store.state
    }

    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<PriKeyState>) -> Subscription<SelectedState>)?
        ) where S.StoreSubscriberStateType == SelectedState {
        store.subscribe(subscriber, transform: transform)
    }

}
