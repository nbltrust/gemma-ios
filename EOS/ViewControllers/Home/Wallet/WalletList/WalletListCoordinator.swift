//
//  WalletListCoordinator.swift
//  EOS
//
//  Created peng zhu on 2018/11/14.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift
import NBLCommonModule

protocol WalletListCoordinatorProtocol {
    func popVC()
    func pushToWalletManagerVC(_ wallet: Wallet)
}

protocol WalletListStateManagerProtocol {
    var state: WalletListState { get }
    func switchPageState(_ state: PageState)
    func switchToWallet(_ wallet: Wallet)
}

class WalletListCoordinator: NavCoordinator {
    var store = Store(
        reducer: gWalletListReducer,
        state: nil,
        middleware: [trackingMiddleware]
    )

    var state: WalletListState {
        return store.state
    }

    override class func start(_ root: BaseNavigationController, context: RouteContext? = nil) -> BaseViewController {
        let currentVC = R.storyboard.wallet.walletListViewController()!
        let coordinator = WalletListCoordinator(rootVC: root)
        currentVC.coordinator = coordinator
        coordinator.store.dispatch(RouteContextAction(context: context))
        return currentVC
    }

    override func register() {
        Broadcaster.register(WalletListCoordinatorProtocol.self, observer: self)
        Broadcaster.register(WalletListStateManagerProtocol.self, observer: self)
    }
}

extension WalletListCoordinator: WalletListCoordinatorProtocol {
    func popVC() {
        self.rootVC.popViewController()
    }

    func pushToWalletManagerVC(_ wallet: Wallet) {
        if let managerVC = R.storyboard.wallet.walletManagerViewController() {
            let coordinator = WalletManagerCoordinator(rootVC: self.rootVC)
            managerVC.coordinator = coordinator
            managerVC.wallet = wallet
            self.rootVC.pushViewController(managerVC, animated: true)
        }
    }
}

extension WalletListCoordinator: WalletListStateManagerProtocol {
    func switchPageState(_ state: PageState) {
        DispatchQueue.main.async {
            self.store.dispatch(PageStateAction(state: state))
        }
    }

    func switchToWallet(_ wallet: Wallet) {
        if let walletId = wallet.id {
            WalletManager.shared.switchWallet(walletId)
            self.popVC()
        }
    }
}
