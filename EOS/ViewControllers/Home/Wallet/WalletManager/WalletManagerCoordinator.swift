//
//  WalletManagerCoordinator.swift
//  EOS
//
//  Created zhusongyu on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

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
