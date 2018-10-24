//
//  GestureLockComfirmCoordinator.swift
//  EOS
//
//  Created peng zhu on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift
import Repeat

protocol GestureLockComfirmCoordinatorProtocol {
    func dismiss()
}

protocol GestureLockComfirmStateManagerProtocol {
    var state: GestureLockComfirmState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<GestureLockComfirmState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState

    func confirmLock(_ password: String)

    func checkGestureLock()

    func lockGestureLock()

    func unLockGestureLock()
}

class GestureLockComfirmCoordinator: NavCoordinator {

    lazy var creator = GestureLockComfirmPropertyActionCreate()

    var timer: Repeater?

    var store = Store<GestureLockComfirmState>(
        reducer: GestureLockComfirmReducer,
        state: nil,
        middleware: [TrackingMiddleware]
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
            addValidCount()
            if password.trimmed.count < GestureLockSetting.minPasswordLength {
                self.store.dispatch(SetConfirmPromotDataAction(data: (R.string.localizable.ges_pas_length_unenough.key.localized(), true, false)))
            } else {
                self.store.dispatch(SetConfirmPromotDataAction(data: (R.string.localizable.ges_confirm_failed.key.localized(), true, false)))
            }
        }
    }

    func addValidCount() {
        var num = self.state.property.reDrawFailedNum.value
        num = num + 1
        if num == GestureLockSetting.reDrawNum {
            lockGestureLock()
            num = 0
        }
        self.store.dispatch(SetReDrawFailedNumAction(num: num))
    }

    func checkGestureLock() {
        if SafeManager.shared.isGestureLockLocked() {
            lockGestureLock()
        } else {
            unLockGestureLock()
        }
    }

    func lockGestureLock() {
        if SafeManager.shared.leftUnLockGestureLockTime() == 0 {
            SafeManager.shared.lockGestureLock()
        }
        self.store.dispatch(SetGestureLockLockedAction(value: true))
        self.timer = Repeater.every(.seconds(1)) {[weak self] _ in
            guard let `self` = self else { return }
            DispatchQueue.main.async {
                let leftTime = SafeManager.shared.leftUnLockGestureLockTime()
                if leftTime > 0 {
                    self.store.dispatch(SetConfirmPromotDataAction(data: (String(format: R.string.localizable.ges_locked.key.localized(), leftTime), true, true)))
                } else {
                    self.unLockGestureLock()
                }
            }
        }

        timer?.start()
    }

    func unLockGestureLock() {
        if self.timer != nil {
            self.timer?.pause()
            self.timer = nil
        }
        self.store.dispatch(SetGestureLockLockedAction(value: false))
        SafeManager.shared.unlockGestureLock()
        self.store.dispatch(SetConfirmPromotDataAction(data: (R.string.localizable.ges_pas_current_pla.key.localized(), false, false)))
    }
}
