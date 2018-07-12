//
//  TransferConfirmCoordinator.swift
//  EOS
//
//  Created 朱宋宇 on 2018/7/12.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

protocol TransferConfirmCoordinatorProtocol {
}

protocol TransferConfirmStateManagerProtocol {
    var state: TransferConfirmState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<TransferConfirmState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState
}

class TransferConfirmCoordinator: TransferRootCoordinator {
    
    lazy var creator = TransferConfirmPropertyActionCreate()
    
    var store = Store<TransferConfirmState>(
        reducer: TransferConfirmReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
}

extension TransferConfirmCoordinator: TransferConfirmCoordinatorProtocol {
    
}

extension TransferConfirmCoordinator: TransferConfirmStateManagerProtocol {
    var state: TransferConfirmState {
        return store.state
    }
    
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<TransferConfirmState>) -> Subscription<SelectedState>)?
        ) where S.StoreSubscriberStateType == SelectedState {
        store.subscribe(subscriber, transform: transform)
    }
    
}
