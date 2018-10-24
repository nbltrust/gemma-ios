//
//  WalletDetailCoordinator.swift
//  EOS
//
//  Created zhusongyu on 2018/10/12.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift
import NBLCommonModule

protocol WalletDetailCoordinatorProtocol {
    func pushToChangeWalletName(model: WalletManagerModel)
}

protocol WalletDetailStateManagerProtocol {
    var state: WalletDetailState { get }

    func switchPageState(_ state: PageState)

    func cancelPair()

    func formmat()
}

class WalletDetailCoordinator: NavCoordinator {
    var store = Store(
        reducer: gWalletDetailReducer,
        state: nil,
        middleware: [trackingMiddleware]
    )

    var state: WalletDetailState {
        return store.state
    }

    override class func start(_ root: BaseNavigationController, context: RouteContext? = nil) -> BaseViewController {
        let vc = R.storyboard.wallet.walletDetailViewController()!
        let coordinator = WalletDetailCoordinator(rootVC: root)
        vc.coordinator = coordinator
        coordinator.store.dispatch(RouteContextAction(context: context))
        return vc
    }

    override func register() {
        Broadcaster.register(WalletDetailCoordinatorProtocol.self, observer: self)
        Broadcaster.register(WalletDetailStateManagerProtocol.self, observer: self)
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

extension WalletDetailCoordinator: WalletDetailCoordinatorProtocol {

}

extension WalletDetailCoordinator: WalletDetailStateManagerProtocol {
    func switchPageState(_ state: PageState) {
        DispatchQueue.main.async {
            self.store.dispatch(PageStateAction(state: state))
        }
    }

    func cancelPair() {

    }

    func formmat() {
        BLTWalletIO.shareInstance()?.formmart({
            if let pub = WalletManager.shared.currentWallet()?.publicKey {
                WalletManager.shared.removeWallet(pub)
            }
        }, failed: { (reason) in
            if let failedReason = reason {
                showFailTop(failedReason)
            }
        })
    }
}
