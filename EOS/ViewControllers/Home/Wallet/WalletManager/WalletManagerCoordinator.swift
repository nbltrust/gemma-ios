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
    func pushToChangeWalletName(model: WalletManagerModel)
    func pushToExportPrivateKey()
    func pushToChangePassword(_ pubKey:String)

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
    func pushToChangePassword(_ pubKey: String) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.appcoordinator?.showPresenterPwd(leftIconType: .dismiss, pubKey: pubKey) { priKey in
                if let vc = R.storyboard.leadIn.setWalletViewController() {
                    vc.coordinator = SetWalletCoordinator(rootVC: self.rootVC)
                    vc.isUpdatePassword = true
                    self.rootVC.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    func pushToExportPrivateKey() {
        
    }
    
    func pushToChangeWalletName(model: WalletManagerModel) {
        if let vc = R.storyboard.wallet.changeWalletNameViewController() {
            let coordinator = ChangeWalletNameCoordinator(rootVC: self.rootVC)
            vc.coordinator = coordinator
            vc.model = model
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
