//
//  GestureLockSetCoordinator.swift
//  EOS
//
//  Created peng zhu on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

enum GestureLockMode: Int {
    case set = 1
    case comfirm
    case update
}

protocol GestureLockSetCoordinatorProtocol {
    func popVC()
}

protocol GestureLockSetStateManagerProtocol {
    var state: GestureLockSetState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<GestureLockSetState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState
    
    func setPassword(_ password: String)
}

class GestureLockSetCoordinator: NavCoordinator {
    
    lazy var creator = GestureLockSetPropertyActionCreate()
    
    var store = Store<GestureLockSetState>(
        reducer: GestureLockSetReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
}

extension GestureLockSetCoordinator: GestureLockSetCoordinatorProtocol {
    func popVC() {
        self.rootVC.popViewController(animated: true)
    }
}

extension GestureLockSetCoordinator: GestureLockSetStateManagerProtocol {
    var state: GestureLockSetState {
        return store.state
    }
    
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<GestureLockSetState>) -> Subscription<SelectedState>)?
        ) where S.StoreSubscriberStateType == SelectedState {
        store.subscribe(subscriber, transform: transform)
    }
    
    func setPassword(_ password: String) {
        if password.count < GestureLockSetting.minPasswordLength {
            self.store.dispatch(SetPromotDataAction(data: (R.string.localizable.ges_pas_length_unenough(), true)))
        } else {
            if !self.state.property.validedPassword.value {
                if self.state.property.password.value.count == 0 {
                    self.store.dispatch(SetPasswordAction(password: password))
                    self.store.dispatch(SetPromotDataAction(data: (R.string.localizable.ges_pas_confirm_pla(), false)))
                } else {
                    if password == self.state.property.password.value {
                        SafeManager.shared.saveGestureLockPassword(password)
                        self.store.dispatch(SetValidedPasswordAction(valided: true))
                    } else {
                        self.store.dispatch(SetPromotDataAction(data: (R.string.localizable.ges_pas_notequal(), false)))
                    }
                }
            }
        }
    }
    
}
