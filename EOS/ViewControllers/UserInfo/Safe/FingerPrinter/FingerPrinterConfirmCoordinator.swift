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
    func dismiss()
}

protocol FingerPrinterConfirmStateManagerProtocol {
    var state: FingerPrinterConfirmState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<FingerPrinterConfirmState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState
    
    func confirm()
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
    func dismiss() {
        self.rootVC.dismiss(animated: true) {
            self.state.callback.confirmResult.value?(false)
        }
    }
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
    
    func confirm() {
        SafeManager.shared.confirmFingerSingerLock(R.string.localizable.fingerid_reason()) {[weak self] (result) in
            guard let `self` = self else { return }
            if result {
                self.rootVC.dismiss(animated: true) {
                    self.state.callback.confirmResult.value?(true)
                }
            }
        }
    }
}
