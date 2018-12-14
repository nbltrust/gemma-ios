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
    func pushToChangeWalletName(model: Wallet)

    func pushToWalletListVC()

    func pushToPairVC()
}

protocol WalletDetailStateManagerProtocol {
    var state: WalletDetailState { get }

    func switchPageState(_ state: PageState)

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

    func pushToChangeWalletName(model: Wallet) {
        if let vc = R.storyboard.wallet.changeWalletNameViewController() {
            let coordinator = ChangeWalletNameCoordinator(rootVC: self.rootVC)
            vc.coordinator = coordinator
            vc.model = model
            self.rootVC.pushViewController(vc, animated: true)
        }
    }

    func pushToWalletListVC() {
        let context = WalletListContext()
        pushVC(WalletListCoordinator.self, animated: true, context: context)
    }

    func pushToPairVC() {

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

    func formmat() {
        handelFormmat()
        waitPowerOn(self.rootVC, promate: R.string.localizable.wookong_power_format.key.localized(), retry: { [weak self] in
            guard let `self` = self else {return}
            self.handelFormmat()
        }) {
            var context = ScreenShotAlertContext()
            context.title = R.string.localizable.wookong_formmat_success.key.localized()
            context.cancelTitle = R.string.localizable.cancel.key.localized()
            context.buttonTitle = R.string.localizable.wookong_init.key.localized()
            context.imageName = R.image.ic_success.name
            context.needCancel = true
            context.sureShot = { [weak self] () in
                guard let `self` = self else { return }
                self.handleVC(true)
            }
            context.cancelShot = { [weak self] () in
                guard let `self` = self else { return }
                self.handleVC(false)
            }
            appCoodinator.showGemmaAlert(context)
        }
    }

    func handelFormmat() {
        BLTWalletIO.shareInstance()?.formmart({

        }, failed: { (reason) in
            if let failedReason = reason {
                showFailTop(failedReason)
            }
        })
    }

    func handleVC(_ isInit: Bool) {
        if let wallet = WalletManager.shared.currentWallet() {
            if WalletManager.shared.removeWallet(wallet) {
                let wallets = WalletManager.shared.walletList()
                if wallets.count == 0 {
                    if let walletVC = self.rootVC.viewControllers[0] as? WalletViewController {
                        self.rootVC.dismiss(animated: false) {}
                        AppConfiguration.shared.appCoordinator!.showEntry()
                    } else {
                        self.rootVC.popToRootViewController(animated: false)
                        AppConfiguration.shared.appCoordinator!.showEntry()
                    }
                } else {
                    let firstWallet = wallets[0]
                    if let walletId = firstWallet.id {
                        WalletManager.shared.switchWallet(walletId)
                    }
                    for itemVC in self.rootVC.viewControllers {
                        if let walletVC = itemVC as? WalletListViewController {
                            if isInit {
                                self.rootVC.popToViewController(walletVC, animated: false)
                                self.pushToPairVC()
                            } else {
                                self.rootVC.popToViewController(walletVC, animated: true)
                            }
                            return
                        }
                    }
                    self.rootVC.popToRootViewController(animated: false)
                    if isInit {
                        self.pushToPairVC()
                    } else {
                        self.pushToWalletListVC()
                    }
                }
            }
        }
    }
}
