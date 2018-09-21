//
//  ChangeWalletNameCoordinator.swift
//  EOS
//
//  Created zhusongyu on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

protocol ChangeWalletNameCoordinatorProtocol {
    func popToLastVC()
}

protocol ChangeWalletNameStateManagerProtocol {
    var state: ChangeWalletNameState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<ChangeWalletNameState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState
    
    func updateWalletName(model: WalletManagerModel) -> Bool
}

class ChangeWalletNameCoordinator: NavCoordinator {
    
    lazy var creator = ChangeWalletNamePropertyActionCreate()
    
    var store = Store<ChangeWalletNameState>(
        reducer: ChangeWalletNameReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
}

extension ChangeWalletNameCoordinator: ChangeWalletNameCoordinatorProtocol {
    func popToLastVC() {
        self.rootVC.popViewController(animated: true)
    }
}

extension ChangeWalletNameCoordinator: ChangeWalletNameStateManagerProtocol {
    var state: ChangeWalletNameState {
        return store.state
    }
    
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<ChangeWalletNameState>) -> Subscription<SelectedState>)?
        ) where S.StoreSubscriberStateType == SelectedState {
        store.subscribe(subscriber, transform: transform)
    }
  
    func updateWalletName(model: WalletManagerModel) -> Bool {
        if isValidWalletName(name: model.name) {
            WalletManager.shared.updateWalletName(model.address, walletName: model.name)
            
            if let vc = self.rootVC.viewControllers[self.rootVC.viewControllers.count - 2] as? WalletManagerViewController {
                vc.data = model
            }
            return true
        } else {
            return false
        }
    }
    
    func isValidWalletName(name: String) -> Bool {
        if name == "" {
            self.rootVC.showError(message: R.string.localizable.walletname_not_empty.key.localized())
            return false
        }
        for walletList in WalletManager.shared.wallketList() {
            if walletList.name == name {
                self.rootVC.showError(message: R.string.localizable.walletname_invalid.key.localized())
                return false
            }
        }
        return true
    }
}
