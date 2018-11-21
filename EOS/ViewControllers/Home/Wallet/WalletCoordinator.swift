//
//  WalletCoordinator.swift
//  EOS
//
//  Created zhusongyu on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

protocol WalletCoordinatorProtocol {
    func dismissVC()
    
    func pushToEntryVC()

    func pushToLeadInWallet()

    func pushToWalletListVC()

    func pushToBLTEntryVC()
}

protocol WalletStateManagerProtocol {
    var state: WalletState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<WalletState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState

    func switchWallet(_ wallet: Wallet)
}

class WalletCoordinator: NavCoordinator {

    lazy var creator = WalletPropertyActionCreate()

    var store = Store<WalletState>(
        reducer: gWalletReducer,
        state: nil,
        middleware: [trackingMiddleware]
    )
}

extension WalletCoordinator: WalletCoordinatorProtocol {
    func dismissVC() {
        self.rootVC.dismiss(animated: true, completion: nil)
    }

    func pushToWalletListVC() {
        let context = WalletListContext()
        pushVC(WalletListCoordinator.self, animated: true, context: context)
    }

    func pushToEntryVC() {
        if let entryVC = R.storyboard.entry.entryViewController() {
            entryVC.createType = .beWalletName
            let coordinator = EntryCoordinator(rootVC: self.rootVC)
            coordinator.state.callback.endCallback.accept {[weak self] in
                guard let `self` = self else { return }
                self.dismissVC()
            }
            entryVC.coordinator = coordinator
            self.rootVC.pushViewController(entryVC, animated: true)
        }
    }

    func pushToLeadInWallet() {
        if let leadinVC = R.storyboard.leadIn.leadInViewController() {
            let coordinator = LeadInCoordinator(rootVC: self.rootVC)
            coordinator.state.callback.fadeCallback.accept {
                self.dismissVC()
            }
            leadinVC.coordinator = coordinator
            self.rootVC.pushViewController(leadinVC, animated: true)
        }
    }

    func pushToBLTEntryVC() {
        if let entryVC = R.storyboard.bltCard.bltCardEntryViewController() {
            let coordinator = BLTCardEntryCoordinator(rootVC: self.rootVC)
            entryVC.coordinator = coordinator
            self.rootVC.pushViewController(entryVC, animated: true)
        }
    }

}

extension WalletCoordinator: WalletStateManagerProtocol {
    var state: WalletState {
        return store.state
    }

    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<WalletState>) -> Subscription<SelectedState>)?
        ) where S.StoreSubscriberStateType == SelectedState {
        store.subscribe(subscriber, transform: transform)
    }

    func switchWallet(_ wallet: Wallet) {
        if let walletId = wallet.id {
            WalletManager.shared.switchWallet(walletId)
        }
    }
}
