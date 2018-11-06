//
//  SetWalletCoordinator.swift
//  EOS
//
//  Created DKM on 2018/7/20.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift
import NBLCommonModule
import seed39_ios_golang
import eos_ios_core_cpp
import SwiftyUserDefaults
import Seed39

protocol SetWalletCoordinatorProtocol {

    func pushToServiceProtocolVC()

    func importFinished()

    func pushToSetAccountVC(_ hint: String)

    func popVC()
}

protocol SetWalletStateManagerProtocol {
    var state: SetWalletState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<SetWalletState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState

    func updatePassword(_ password: String, hint: String)

    func validName(_ valid: Bool)

    func validPassword(_ valid: Bool)

    func validComfirmPassword(_ valid: Bool)

    func checkAgree(_ agree: Bool)

    func importPriKeyWallet(_ name: String, priKey: String, type: CurrencyType, password: String, hint: String, success: @escaping SuccessedComplication, failed: @escaping FailedComplication)

    func importMnemonicWallet(_ name: String, mnemonic: String, password: String, hint: String, success: @escaping SuccessedComplication, failed: @escaping FailedComplication)

    func setWalletPin(_ password: String, success: @escaping SuccessedComplication, failed: @escaping FailedComplication)
    
    func updatePin(_ new: String, success: @escaping SuccessedComplication, failed: @escaping FailedComplication)
}

class SetWalletCoordinator: NavCoordinator {

    lazy var creator = SetWalletPropertyActionCreate()

    var store = Store<SetWalletState>(
        reducer: gSetWalletReducer,
        state: nil,
        middleware: [trackingMiddleware]
    )

    override func register() {
        Broadcaster.register(SetWalletCoordinatorProtocol.self, observer: self)
        Broadcaster.register(SetWalletStateManagerProtocol.self, observer: self)
    }
}

extension SetWalletCoordinator: SetWalletCoordinatorProtocol {

    func pushToServiceProtocolVC() {
        let serviceVC = BaseWebViewController()
        serviceVC.url = H5AddressConfiguration.RegisterProtocolURL
        serviceVC.title = R.string.localizable.service_protocol.key.localized()
        self.rootVC.pushViewController(serviceVC, animated: true)
    }

    func importFinished() {
        if let _ = self.rootVC.viewControllers[0] as? EntryGuideViewController {
            self.dismissCurrentNav(self.rootVC.viewControllers[1])
        } else {
            self.rootVC.popToRootViewController(animated: true)
        }
    }

    func pushToSetAccountVC(_ hint: String) {
        let entryVC = R.storyboard.entry.entryViewController()!
        entryVC.createType = .wookong
        entryVC.hint = hint
        let accountCoordinator = EntryCoordinator(rootVC: self.rootVC)
        entryVC.coordinator = accountCoordinator
        self.rootVC.pushViewController(entryVC, animated: true)
    }

    func popVC() {
        self.rootVC.popViewController(animated: true)
    }
}

extension SetWalletCoordinator: SetWalletStateManagerProtocol {
    var state: SetWalletState {
        return store.state
    }

    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<SetWalletState>) -> Subscription<SelectedState>)?
        ) where S.StoreSubscriberStateType == SelectedState {
        store.subscribe(subscriber, transform: transform)
    }

    func updatePassword(_ password: String, hint: String) {
        WalletManager.shared.updateWalletPassword(password, hint: hint)
        self.rootVC.popViewController()
    }

    func validName(_ valid: Bool) {
        self.store.dispatch(SetWalletNameAction(isValid: valid))
    }

    func validPassword(_ valid: Bool) {
        self.store.dispatch(SetWalletPasswordAction(isValid: valid))
    }

    func validComfirmPassword(_ valid: Bool) {
        self.store.dispatch(SetWalletComfirmPasswordAction(isValid: valid))
    }

    func checkAgree(_ agree: Bool) {
        self.store.dispatch(SetWalletAgreeAction(isAgree: agree))
    }

    func importPriKeyWallet(_ name: String, priKey: String, type: CurrencyType, password: String, hint: String, success: @escaping SuccessedComplication, failed: @escaping FailedComplication) {
        if type == .EOS {
            if let pubkey = EOSIO.getPublicKey(priKey) {
                WalletManager.shared.getEOSAccountNames(pubkey) { (result, accounts) in
                    if result {
                        do {
                            //Wallet
                            let date = Date.init()
                            let wallet = Wallet(id: nil, name: name, type: .HD, cipher: "", deviceName: nil, date: date)
                            if let walletId = try WalletCacheService.shared.insertWallet(wallet: wallet) {
                                //currency
                                let currency = Currency(id: nil, type: type, cipher: "", pubKey: pubkey, wid: walletId, date: date, address: nil)
                                if let currencyId = try WalletCacheService.shared.insertCurrency(currency) {
                                    CurrencyManager.shared.saveAccountNamesWith(currencyId, accounts: accounts)
                                    if accounts.count > 0 {
                                        CurrencyManager.shared.saveAccountNameWith(currencyId, name: accounts[0])
                                    }
                                }
                                Defaults[.currentWalletID] = walletId.string
                                success()
                            }
                        } catch {
                            failed(R.string.localizable.wallet_create_failed.key.localized())
                        }
                    }
                }
            }
        }
    }

    func importMnemonicWallet(_ name: String, mnemonic: String, password: String, hint: String, success: @escaping SuccessedComplication, failed: @escaping FailedComplication) {
        let seed = Seed39SeedByMnemonic(mnemonic)
        if let prikey = Seed39DeriveWIF(seed, CurrencyType.EOS.derivationPath, true) {
            importPriKeyWallet(name, priKey: prikey, type: .EOS, password: password, hint: hint, success: success, failed: failed)
        } else {
            failed(R.string.localizable.wallet_create_failed.key.localized())
        }
    }

    func setWalletPin(_ password: String, success: @escaping SuccessedComplication, failed: @escaping FailedComplication) {
        BLTWalletIO.shareInstance().initPin(password, success: success, failed: failed)
    }

    func updatePin(_ new: String, success: @escaping SuccessedComplication, failed: @escaping FailedComplication) {
        BLTWalletIO.shareInstance()?.updatePin(new, success: success, failed: failed)
    }

    func dismissCurrentNav(_ entry: UIViewController? = nil) {
        if let entry = entry as? LeadInViewController {
            entry.coordinator?.state.callback.fadeCallback.value?()
            return
        }
        if let vc = self.rootVC.viewControllers[self.rootVC.viewControllers.count - 2] as? LeadInViewController {
            vc.coordinator?.state.callback.fadeCallback.value?()
        }
    }

}
