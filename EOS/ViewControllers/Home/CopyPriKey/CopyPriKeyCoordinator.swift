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
}

protocol CopyPriKeyStateManagerProtocol {
    var state: CopyPriKeyState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<CopyPriKeyState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState
}

class CopyPriKeyCoordinator: HomeRootCoordinator {
    
    lazy var creator = CopyPriKeyPropertyActionCreate()
    
    var store = Store<CopyPriKeyState>(
        reducer: CopyPriKeyReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
}

extension CopyPriKeyCoordinator: CopyPriKeyCoordinatorProtocol {
    func showAlertMessage() {
        let width = ModalSize.custom(size: 270)
        let height = ModalSize.custom(size: 230)
        let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: (UIScreen.main.bounds.width-270)/2, y: UIScreen.main.bounds.height/2-115))
        let customType = PresentationType.custom(width: width, height: height, center: center)
        
        let presenter = Presentr(presentationType: customType)
        presenter.keyboardTranslationType = .stickToTop
        
        if let vc = R.storyboard.screenShotAlert.screenShotAlertViewController() {
            let coordinator = ScreenShotAlertCoordinator(rootVC: self.rootVC)
            vc.coordinator = coordinator
            self.rootVC.topViewController?.customPresentViewController(presenter, viewController: vc, animated: false, completion: nil)
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
