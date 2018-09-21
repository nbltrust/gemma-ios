//
//  ScreenShotAlertCoordinator.swift
//  EOS
//
//  Created zhusongyu on 2018/8/2.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

protocol ScreenShotAlertCoordinatorProtocol {
    func dismiss()
}

protocol ScreenShotAlertStateManagerProtocol {
    var state: ScreenShotAlertState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<ScreenShotAlertState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState
}

class ScreenShotAlertCoordinator: NavCoordinator {
    
    lazy var creator = ScreenShotAlertPropertyActionCreate()
    
    var store = Store<ScreenShotAlertState>(
        reducer: ScreenShotAlertReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
}

extension ScreenShotAlertCoordinator: ScreenShotAlertCoordinatorProtocol {
    func dismiss() {
        self.rootVC.dismiss(animated: true) {
            
        }
    }
}

extension ScreenShotAlertCoordinator: ScreenShotAlertStateManagerProtocol {
    var state: ScreenShotAlertState {
        return store.state
    }
    
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<ScreenShotAlertState>) -> Subscription<SelectedState>)?
        ) where S.StoreSubscriberStateType == SelectedState {
        store.subscribe(subscriber, transform: transform)
    }
    
}
