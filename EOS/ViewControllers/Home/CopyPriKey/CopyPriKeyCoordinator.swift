//
//  CopyPriKeyCoordinator.swift
//  EOS
//
//  Created peng zhu on 2018/8/1.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift
import Presentr

protocol CopyPriKeyCoordinatorProtocol {
    func showAlertMessage()
    func finishCopy()
    func pushVerifyPriKey()
}

protocol CopyPriKeyStateManagerProtocol {
    var state: CopyPriKeyState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<CopyPriKeyState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState
}

class CopyPriKeyCoordinator: NavCoordinator {
    
    lazy var creator = CopyPriKeyPropertyActionCreate()
    
    var store = Store<CopyPriKeyState>(
        reducer: CopyPriKeyReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
}

extension CopyPriKeyCoordinator: CopyPriKeyCoordinatorProtocol {
    func showAlertMessage() {
        let presenter = Presentr(presentationType: PresentationType.fullScreen)
        presenter.keyboardTranslationType = .stickToTop
        
        presentVCNoNav(ScreenShotAlertCoordinator.self, context: nil) { (top, target) in
            top.customPresentViewController(presenter, viewController: target, animated: true)
        }
    }
    
    func finishCopy() {
        if let pubKey = EOSIO.getPublicKey(WalletManager.shared.priKey) {
            WalletManager.shared.backupSuccess(pubKey)
        }
        if let lastVC = self.rootVC.viewControllers[self.rootVC.viewControllers.count - 2] as? BackupPrivateKeyViewController {
            lastVC.coordinator?.state.callback.hadSaveCallback.value?()
        }
    }
    
    func pushVerifyPriKey() {
        pushVC(VerifyPriKeyCoordinator.self, animated: true, context: nil)
    }
}

extension CopyPriKeyCoordinator: CopyPriKeyStateManagerProtocol {
    var state: CopyPriKeyState {
        return store.state
    }
    
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<CopyPriKeyState>) -> Subscription<SelectedState>)?
        ) where S.StoreSubscriberStateType == SelectedState {
        store.subscribe(subscriber, transform: transform)
    }
    
}
