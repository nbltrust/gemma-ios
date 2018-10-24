//
//  PaymentsDetailCoordinator.swift
//  EOS
//
//  Created 朱宋宇 on 2018/7/10.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

protocol PaymentsDetailCoordinatorProtocol {
}

protocol PaymentsDetailStateManagerProtocol {
    var state: PaymentsDetailState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<PaymentsDetailState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState
}

class PaymentsDetailCoordinator: HomeRootCoordinator {

    lazy var creator = PaymentsDetailPropertyActionCreate()

    var store = Store<PaymentsDetailState>(
        reducer: PaymentsDetailReducer,
        state: nil,
        middleware: [TrackingMiddleware]
    )
}

extension PaymentsDetailCoordinator: PaymentsDetailCoordinatorProtocol {

}

extension PaymentsDetailCoordinator: PaymentsDetailStateManagerProtocol {
    var state: PaymentsDetailState {
        return store.state
    }

    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<PaymentsDetailState>) -> Subscription<SelectedState>)?
        ) where S.StoreSubscriberStateType == SelectedState {
        store.subscribe(subscriber, transform: transform)
    }

}
