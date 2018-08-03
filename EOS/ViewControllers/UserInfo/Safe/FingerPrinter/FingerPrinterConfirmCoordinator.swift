//
//  FingerPrinterConfirmCoordinator.swift
//  EOS
//
//  Created peng zhu on 2018/8/3.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

protocol FingerPrinterConfirmCoordinatorProtocol {
}

protocol FingerPrinterConfirmStateManagerProtocol {
    var state: FingerPrinterConfirmState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<FingerPrinterConfirmState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState
}

class FingerPrinterConfirmCoordinator: UserInfoRootCoordinator {
    
    lazy var creator = FingerPrinterConfirmPropertyActionCreate()
    
    var store = Store<FingerPrinterConfirmState>(
        reducer: FingerPrinterConfirmReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
}

extension FingerPrinterConfirmCoordinator: FingerPrinterConfirmCoordinatorProtocol {
    
}

extension FingerPrinterConfirmCoordinator: FingerPrinterConfirmStateManagerProtocol {
    var state: FingerPrinterConfirmState {
        return store.state
    }
    
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<FingerPrinterConfirmState>) -> Subscription<SelectedState>)?
        ) where S.StoreSubscriberStateType == SelectedState {
        store.subscribe(subscriber, transform: transform)
    }
    
}
