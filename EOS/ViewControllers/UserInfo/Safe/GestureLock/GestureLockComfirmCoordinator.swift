//
//  GestureLockComfirmCoordinator.swift
//  EOS
//
//  Created peng zhu on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

protocol GestureLockComfirmCoordinatorProtocol {
    func dismiss()
}

protocol GestureLockComfirmStateManagerProtocol {
    var state: GestureLockComfirmState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<GestureLockComfirmState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState
    
    func confirmLock(_ password: String)
}

class GestureLockComfirmCoordinator: NavCoordinator {
    
    lazy var creator = GestureLockComfirmPropertyActionCreate()
    
    var store = Store<GestureLockComfirmState>(
        reducer: GestureLockComfirmReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
}

extension GestureLockComfirmCoordinator: GestureLockComfirmCoordinatorProtocol {
    func dismiss() {
        self.rootVC.dismiss(animated: true) {
            self.state.callback.confirmResult.value?(false)
        }
    }
}

extension GestureLockComfirmCoordinator: GestureLockComfirmStateManagerProtocol {
    var state: GestureLockComfirmState {
        return store.state
    }
    
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<GestureLockComfirmState>) -> Subscription<SelectedState>)?
        ) where S.StoreSubscriberStateType == SelectedState {
        store.subscribe(subscriber, transform: transform)
    }
    
    func confirmLock(_ password: String) {
        if SafeManager.shared.validGesturePassword(password) {
            self.rootVC.dismiss(animated: true) {
                self.state.callback.confirmResult.value?(true)
            }
        } else {
            if password.trimmed.count < GestureLockSetting.minPasswordLength {
                self.store.dispatch(SetPromotDataAction(data: (R.string.localizable.ges_pas_length_unenough(), true)))
            } else {
                self.store.dispatch(SetPromotDataAction(data: (R.string.localizable.ges_confirm_failed(), true)))
            }
        }
    }
    
}
