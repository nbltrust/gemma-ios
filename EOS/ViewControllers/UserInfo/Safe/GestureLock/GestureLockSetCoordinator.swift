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
    
    func addValidCount()
    
    func clear()
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
            self.store.dispatch(SetPromotDataAction(data: (R.string.localizable.ges_pas_length_unenough.key.localized(), true)))
            addValidCount()
        } else {
            if !self.state.property.validedPassword.value {
                if self.state.property.password.value.count == 0 {
                    self.store.dispatch(SetPasswordAction(password: password))
                    self.store.dispatch(SetPromotDataAction(data: (R.string.localizable.ges_pas_confirm_pla.key.localized(), false)))
                } else {
                    if password == self.state.property.password.value {
                        SafeManager.shared.saveGestureLockPassword(password)
                        self.store.dispatch(SetValidedPasswordAction(valided: true))
                    } else {
                        self.state.callback.setResult.value!(true)
                        self.store.dispatch(SetPromotDataAction(data: (R.string.localizable.ges_pas_notequal.key.localized(), true)))
                        addValidCount()
                    }
                }
            }
        }
    }
    
    func addValidCount() {
        var num = self.state.property.reDrawFailedNum.value
        num = num + 1
        if num == GestureLockSetting.reDrawNum {
            self.clear()
            num = 0
        }
        self.store.dispatch(SetReDrawFailedNumAction(num: num))
    }
    
    func clear() {
        self.store.dispatch(SetPasswordAction(password: ""))
        self.store.dispatch(SetPromotDataAction(data: (R.string.localizable.ges_pas_input_pla.key.localized(), false)))
        self.store.dispatch(SetValidedPasswordAction(valided: false))
    }
}
