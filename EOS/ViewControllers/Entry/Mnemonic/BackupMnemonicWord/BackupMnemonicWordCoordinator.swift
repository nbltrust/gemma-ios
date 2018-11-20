//
//  BackupMnemonicWordCoordinator.swift
//  EOS
//
//  Created zhusongyu on 2018/9/14.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift
import NBLCommonModule

protocol BackupMnemonicWordCoordinatorProtocol {
    func pushToMnemonicWordContentVC()
}

protocol BackupMnemonicWordStateManagerProtocol {
    var state: BackupMnemonicWordState { get }

    func switchPageState(_ state: PageState)
}

class BackupMnemonicWordCoordinator: NavCoordinator {
    var store = Store(
        reducer: gBackupMnemonicWordReducer,
        state: nil,
        middleware: [trackingMiddleware]
    )

    var state: BackupMnemonicWordState {
        return store.state
    }

    override func register() {
        Broadcaster.register(BackupMnemonicWordCoordinatorProtocol.self, observer: self)
        Broadcaster.register(BackupMnemonicWordStateManagerProtocol.self, observer: self)
    }
}

extension BackupMnemonicWordCoordinator: BackupMnemonicWordCoordinatorProtocol {
    func pushToMnemonicWordContentVC() {
        var currencyID: Int64?
        if let wallet = WalletManager.shared.currentWallet() {
            let currencys = try? WalletCacheService.shared.fetchAllCurrencysBy(wallet)
            if let currencys = currencys as? [Currency] {
                currencyID = currencys[0].id
            }
        }
        appCoodinator.showPresenterPwd(leftIconType: .dismiss, currencyID: currencyID, type: ConfirmType.backupMnemonic.rawValue, producers: []) {[weak self] (mnemonic) in

            guard let `self` = self else { return }
            if let vc = R.storyboard.mnemonic.mnemonicContentViewController() {
                let coordinator = MnemonicContentCoordinator(rootVC: self.rootVC)
                vc.coordinator = coordinator
                vc.mnemonic = mnemonic
                self.rootVC.pushViewController(vc, animated: true)
            }
        }
    }
}

extension BackupMnemonicWordCoordinator: BackupMnemonicWordStateManagerProtocol {
    func switchPageState(_ state: PageState) {
        DispatchQueue.main.async {
            self.store.dispatch(PageStateAction(state: state))
        }
    }
}
