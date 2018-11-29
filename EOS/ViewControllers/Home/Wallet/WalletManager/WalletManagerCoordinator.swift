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
    func pushToChangeWalletName(_ model: Wallet)
    func pushToWookongBioDetail(_ model: Wallet)
    func pushToExportPrivateKey(_ model: Wallet)
    func pushToChangePassword(_ model : Wallet)
    func pushToBackupMnemonicVC()
    func pushToFingerVC(_ model: Wallet)
}

protocol WalletManagerStateManagerProtocol {
    var state: WalletManagerState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<WalletManagerState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState

    func connect(_ complicatiopn: @escaping CompletionCallback)

    func disConnect(_ complication: @escaping CompletionCallback)

    func getFPList(_ success: @escaping GetFPListComplication, failed: @escaping FailedComplication)
}

class WalletManagerCoordinator: NavCoordinator {

    lazy var creator = WalletManagerPropertyActionCreate()

    var store = Store<WalletManagerState>(
        reducer: gWalletManagerReducer,
        state: nil,
        middleware: [trackingMiddleware]
    )
}

extension WalletManagerCoordinator: WalletManagerCoordinatorProtocol {
    //助记词调试代码
    func pushToBackupMnemonicVC() {
        if let vc = R.storyboard.mnemonic.backupMnemonicWordViewController() {
            let coordinator = BackupMnemonicWordCoordinator(rootVC: self.rootVC)
            vc.coordinator = coordinator
            self.rootVC.pushViewController(vc, animated: true)
        }
    }

    func pushToWookongBioDetail(_ model: Wallet) {
        if BLTWalletIO.shareInstance()?.isConnection() ?? false {
            if let detailVC = R.storyboard.wallet.walletDetailViewController() {
                let coordinator = WalletDetailCoordinator(rootVC: self.rootVC)
                detailVC.coordinator = coordinator
                detailVC.model = model
                self.rootVC.pushViewController(detailVC, animated: true)
            }
        }
    }

    func pushToChangePassword(_ model: Wallet) {
        if let walletVC = R.storyboard.leadIn.setWalletViewController() {
            let coordinator = SetWalletCoordinator(rootVC: self.rootVC)
            walletVC.coordinator = coordinator
            walletVC.settingType = .updatePas
            walletVC.wallet = model
            self.rootVC.pushViewController(walletVC, animated: true)
        }
    }

    func pushToExportPrivateKey(_ model: Wallet) {
        var context = WalletCurrencyListContext()
        context.wallet = model
        pushVC(WalletCurrencyListCoordinator.self, animated: true, context: context)
    }

    func pushToChangeWalletName(_ model: Wallet) {
        if let nameVC = R.storyboard.wallet.changeWalletNameViewController() {
            let coordinator = ChangeWalletNameCoordinator(rootVC: self.rootVC)
            nameVC.coordinator = coordinator
            nameVC.model = model
            self.rootVC.pushViewController(nameVC, animated: true)
        }
    }

    func pushToFingerVC(_ model: Wallet) {
        if let fingerVC = R.storyboard.wallet.fingerViewController() {
            let coordinator = FingerCoordinator(rootVC: self.rootVC)
            fingerVC.coordinator = coordinator
            fingerVC.model = model
            self.rootVC.pushViewController(fingerVC, animated: true)
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

    func connect(_ complicatiopn: @escaping CompletionCallback) {
        connectBLTCard(self.rootVC, complication: complicatiopn)
    }

    func disConnect(_ complication: @escaping CompletionCallback) {
        BLTWalletIO.shareInstance()?.disConnect({
            complication()
        }, failed: {  (reason) in
            if let failedReason = reason {
                showFailTop(failedReason)
            }
        })
    }

    func getFPList(_ success: @escaping GetFPListComplication, failed: @escaping FailedComplication) {
        BLTWalletIO.shareInstance()?.getFPList(success, failed: failed)
    }
}
