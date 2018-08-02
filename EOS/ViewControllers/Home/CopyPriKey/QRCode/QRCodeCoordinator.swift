//
//  QRCodeCoordinator.swift
//  EOS
//
//  Created peng zhu on 2018/8/1.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

protocol QRCodeCoordinatorProtocol {
}

protocol QRCodeStateManagerProtocol {
    var state: QRCodeState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<QRCodeState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState
}

class QRCodeCoordinator: HomeRootCoordinator {
    
    lazy var creator = QRCodePropertyActionCreate()
    
    var store = Store<QRCodeState>(
        reducer: QRCodeReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
}

extension QRCodeCoordinator: QRCodeCoordinatorProtocol {
}

extension QRCodeCoordinator: QRCodeStateManagerProtocol {
    var state: QRCodeState {
        return store.state
    }
    
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<QRCodeState>) -> Subscription<SelectedState>)?
        ) where S.StoreSubscriberStateType == SelectedState {
        store.subscribe(subscriber, transform: transform)
    }
    
}
