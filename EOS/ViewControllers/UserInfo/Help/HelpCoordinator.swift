//
//  HelpCoordinator.swift
//  EOS
//
//  Created DKM on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

protocol HelpCoordinatorProtocol {
}

protocol HelpStateManagerProtocol {
    var state: HelpState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<HelpState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState
}

class HelpCoordinator: NavCoordinator {

    lazy var creator = HelpPropertyActionCreate()

    var store = Store<HelpState>(
        reducer: HelpReducer,
        state: nil,
        middleware: [TrackingMiddleware]
    )
}

extension HelpCoordinator: HelpCoordinatorProtocol {

}

extension HelpCoordinator: HelpStateManagerProtocol {
    var state: HelpState {
        return store.state
    }

    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<HelpState>) -> Subscription<SelectedState>)?
        ) where S.StoreSubscriberStateType == SelectedState {
        store.subscribe(subscriber, transform: transform)
    }

}
