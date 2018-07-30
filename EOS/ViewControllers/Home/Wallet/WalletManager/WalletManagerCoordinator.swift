//
//  WalletManagerCoordinator.swift
//  EOS
//
//  Created zhusongyu on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift
import Presentr

protocol WalletManagerCoordinatorProtocol {
    func pushToChangeWalletName(name: String)
    func pushToExportPrivateKey()
    func pushToChangePassword()

}

protocol WalletManagerStateManagerProtocol {
    var state: WalletManagerState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<WalletManagerState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState
}

class WalletManagerCoordinator: HomeRootCoordinator {
    
    lazy var creator = WalletManagerPropertyActionCreate()
    
    var store = Store<WalletManagerState>(
        reducer: WalletManagerReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
}

extension WalletManagerCoordinator: WalletManagerCoordinatorProtocol {
    func pushToChangePassword() {
        let width = ModalSize.full
        let height = ModalSize.custom(size: 271)
        let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: 0, y: UIScreen.main.bounds.height - 271))
        let customType = PresentationType.custom(width: width, height: height, center: center)
        
        let presenter = Presentr(presentationType: customType)
        presenter.keyboardTranslationType = .moveUp
        
        let newVC = BaseNavigationController()
        newVC.navStyle = .white
        let transferConfirmpwd = TransferConfirmPasswordRootCoordinator(rootVC: newVC)

        self.rootVC.topViewController?.customPresentViewController(presenter, viewController: newVC, animated: true, completion: nil)
        transferConfirmpwd.start()
    }
    
    func pushToExportPrivateKey() {
        
    }
    
    func pushToChangeWalletName(name: String) {
        if let vc = R.storyboard.wallet.changeWalletNameViewController() {
            let coordinator = ChangeWalletNameCoordinator(rootVC: self.rootVC)
            vc.coordinator = coordinator
            vc.name = name
            self.rootVC.pushViewController(vc, animated: true)
        }
    }
    
    
}

extension WalletManagerCoordinator: WalletManagerStateManagerProtocol {
    var state: WalletManagerState {
        return store.state
    }
    
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<WalletManagerState>) -> Subscription<SelectedState>)?
        ) where S.StoreSubscriberStateType == SelectedState {
        store.subscribe(subscriber, transform: transform)
    }
    
}
