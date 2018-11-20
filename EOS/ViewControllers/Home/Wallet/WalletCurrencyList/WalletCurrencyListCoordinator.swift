//
//  WalletCurrencyListCoordinator.swift
//  EOS
//
//  Created peng zhu on 2018/11/15.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift
import NBLCommonModule

protocol WalletCurrencyListCoordinatorProtocol {
}

protocol WalletCurrencyListStateManagerProtocol {
    var state: WalletCurrencyListState { get }

    func switchPageState(_ state: PageState)
}

class WalletCurrencyListCoordinator: NavCoordinator {
    var store = Store(
        reducer: gWalletCurrencyListReducer,
        state: nil,
        middleware: [trackingMiddleware]
    )
    
    var state: WalletCurrencyListState {
        return store.state
    }
    
    override class func start(_ root: BaseNavigationController, context: RouteContext? = nil) -> BaseViewController {
        let currentVC = R.storyboard.wallet.walletCurrencyListViewController()!
        let coordinator = WalletCurrencyListCoordinator(rootVC: root)
        currentVC.coordinator = coordinator
        coordinator.store.dispatch(RouteContextAction(context: context))
        return currentVC
    }

    override func register() {
        Broadcaster.register(WalletCurrencyListCoordinatorProtocol.self, observer: self)
        Broadcaster.register(WalletCurrencyListStateManagerProtocol.self, observer: self)
    }
}

extension WalletCurrencyListCoordinator: WalletCurrencyListCoordinatorProtocol {
}

extension WalletCurrencyListCoordinator: WalletCurrencyListStateManagerProtocol {
    func switchPageState(_ state: PageState) {
        DispatchQueue.main.async {
            self.store.dispatch(PageStateAction(state: state))
        }
    }
}
