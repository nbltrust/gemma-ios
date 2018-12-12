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

    func updateWalletName(model: Wallet, newName: String) -> Bool
    func updateFingerName(model: Wallet, index: Int, newName: String) -> Bool
}

class ChangeWalletNameCoordinator: NavCoordinator {

    lazy var creator = ChangeWalletNamePropertyActionCreate()

    var store = Store<ChangeWalletNameState>(
        reducer: gChangeWalletNameReducer,
        state: nil,
        middleware: [trackingMiddleware]
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

    func updateWalletName(model: Wallet, newName: String) -> Bool {
        if isValidWalletName(name: newName, wallet: model), let walletID = model.id {
            WalletManager.shared.updateWalletName(walletID, newName: newName)
            var model = model
            model.name = newName
            if let vc = self.rootVC.viewControllers[self.rootVC.viewControllers.count - 2] as? WalletManagerViewController {
                vc.wallet = model
            }
            if let vc = self.rootVC.viewControllers[self.rootVC.viewControllers.count - 3] as? WalletManagerViewController {
                vc.wallet = model
            }
            if let vc = self.rootVC.viewControllers[self.rootVC.viewControllers.count - 2] as? WalletDetailViewController {
                vc.model = model
            }
            return true
        } else {
            return false
        }
    }

    func updateFingerName(model: Wallet, index: Int, newName: String) -> Bool {
        if isValidFingernName(name: newName) {
            FingerManager.shared.updateFingerName(model, index: index, fingerName: newName)

            if let vc = self.rootVC.viewControllers[self.rootVC.viewControllers.count - 2] as? DeleteFingerViewController {
                vc.model = model
            }
            return true
        } else {
            return false
        }
    }

    func isValidFingernName(name: String) -> Bool {
        if name.isEmpty {
            self.rootVC.showError(message: R.string.localizable.finger_name_empty.key.localized())
            return false
        }
        return true
    }

    func isValidWalletName(name: String, wallet: Wallet) -> Bool {
        if name.isEmpty {
            self.rootVC.showError(message: R.string.localizable.walletname_not_empty.key.localized())
            return false
        }
        for item in WalletManager.shared.walletList() {
            let notCurrent = (item.id != wallet.id)
            let equal = (item.name == name)
            if notCurrent && equal {
                self.rootVC.showError(message: R.string.localizable.walletname_invalid.key.localized())
                return false
            }
        }
        return true
    }
}
