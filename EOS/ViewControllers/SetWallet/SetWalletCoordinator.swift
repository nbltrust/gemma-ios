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
import Presentr

protocol SetWalletCoordinatorProtocol {

    func pushToServiceProtocolVC()

    func importFinished()

    func pushToSetAccountVC(_ hint: String)

    func pushToMnemonicVC()

    func pushToImportVC()

    func popVC()

    func dismissNav()

    func presentSetFingerPrinterVC()

    func presentBLTInitTypeSelectVC(_ password: String)
}

protocol SetWalletStateManagerProtocol {
    var state: SetWalletState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<SetWalletState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState

    func updatePassword(_ wallet: Wallet, oldPassword: String, newPassword: String, hint: String)

    func validName(_ valid: Bool)

    func validPassword(_ valid: Bool)

    func validComfirmPassword(_ valid: Bool)

    func validOraginalPassword(_ valid: Bool)

    func checkAgree(_ agree: Bool)

    func importPriKeyWallet(_ name: String,
                            priKey: String,
                            type: CurrencyType,
                            password: String,
                            hint: String,
                            success: @escaping SuccessedComplication,
                            failed: @escaping FailedComplication)

    func importMnemonicWallet(_ name: String,
                              mnemonic: String,
                              password: String,
                              hint: String,
                              success: @escaping SuccessedComplication,
                              failed: @escaping FailedComplication)

    func setWalletPin(_ password: String,
                      failed: @escaping FailedComplication)

    func updatePin(_ new: String,
                   success: @escaping SuccessedComplication,
                   failed: @escaping FailedComplication)
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
        appCoodinator.endEntry()
    }

    func pushToMnemonicVC() {
        let mnemonicWordVC = R.storyboard.mnemonic.backupMnemonicWordViewController()
        let coor = BackupMnemonicWordCoordinator(rootVC: self.rootVC)
        mnemonicWordVC?.coordinator = coor
        mnemonicWordVC?.isWookong = true
        self.rootVC.pushViewController(mnemonicWordVC!, animated: true)
    }

    func pushToImportVC() {
        let leadInVC = R.storyboard.leadIn.leadInViewController()!
        let coordinator = LeadInCoordinator(rootVC: self.rootVC)
        leadInVC.coordinator = coordinator
        self.rootVC.pushViewController(leadInVC, animated: true)
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

    func dismissNav() {
        self.rootVC.dismiss(animated: false) {
            self.presentSetFingerPrinterVC()
        }
    }

    func presentSetFingerPrinterVC() {
        let newHomeNav = appCoodinator.newHomeCoordinator.rootVC
        let printerVC = R.storyboard.bltCard.bltCardSetFingerPrinterViewController()!
        let nav = BaseNavigationController.init(rootViewController: printerVC)
        let coor = BLTCardSetFingerPrinterCoordinator(rootVC: nav)
        printerVC.coordinator = coor
        newHomeNav?.present(nav, animated: true, completion: nil)
    }

    func presentBLTInitTypeSelectVC(_ password: String) {
        selectBLTInitType(self.rootVC) { [weak self] (isCreate) in
            guard let `self` = self else {return}
            self.setWalletPin(password, failed: { (reason) in
                if let failedReason = reason {
                    showFailTop(failedReason)
                }
            })
            waitPowerOn(self.rootVC, promate: R.string.localizable.wookong_power_init.key.localized(), retry: {
                self.setWalletPin(password, failed: { (reason) in
                    if let failedReason = reason {
                        showFailTop(failedReason)
                    }
                })
            }, complication: {
                if isCreate {
                    self.pushToMnemonicVC()
                } else {
                    self.pushToImportVC()
                }
            })
        }
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

    func updatePassword(_ wallet: Wallet, oldPassword: String, newPassword: String, hint: String) {
        let isSuccess = WalletManager.shared.updateWalletPassword(wallet, oldPassword: oldPassword, newPassword: newPassword, hint: hint)
        if isSuccess == true {
            self.rootVC.popViewController()
        }
    }

    func validName(_ valid: Bool) {
        self.store.dispatch(SetWalletNameAction(isValid: valid))
    }

    func validOraginalPassword(_ valid: Bool) {
        self.store.dispatch(SetWalletOriginalPasswordAction(isValid: valid))
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

    func importPriKeyWallet(_ name: String,
                            priKey: String,
                            type: CurrencyType,
                            password: String,
                            hint: String,
                            success: @escaping SuccessedComplication,
                            failed: @escaping FailedComplication) {
        let model = ImportWalletModel.init(walletType: .nonHD,
                                           name: name,
                                           priKey: priKey,
                                           currencySetting: [type],
                                           password: password,
                                           hint: hint,
                                           mnemonic: "")
        importWallet(model, success: success, failed: failed)
    }

    func importMnemonicWallet(_ name: String,
                              mnemonic: String,
                              password: String,
                              hint: String,
                              success: @escaping SuccessedComplication,
                              failed: @escaping FailedComplication) {
        let seed = Seed39SeedByMnemonic(mnemonic)
        if let prikey = Seed39DeriveWIF(seed, CurrencyType.EOS.derivationPath, true) {
            let model = ImportWalletModel.init(walletType: .nonHD,
                                               name: name,
                                               priKey: prikey,
                                               currencySetting: SupportCurrency.data,
                                               password: password,
                                               hint: hint,
                                               mnemonic: mnemonic)
            importWallet(model, success: success, failed: failed)
        } else {
            failed(R.string.localizable.wallet_create_failed.key.localized())
        }
    }

    func importWallet(_ model: ImportWalletModel,
                      success: @escaping SuccessedComplication,
                      failed: @escaping FailedComplication) {
        if let pubkey = EOSIO.getPublicKey(model.priKey) {
            do {
                let date = Date.init()
                var walletCipher = ""
                if model.walletType == .HD {
                    walletCipher = Seed39KeyEncrypt(model.password, model.mnemonic)
                }

                let wallet = Wallet(id: nil, name: model.name, type: model.walletType, cipher: walletCipher, deviceName: nil, date: date, hint: model.hint)
                if let walletId = try WalletCacheService.shared.insertWallet(wallet: wallet) {
                    if model.currencySetting.contains(.EOS) {
                        if let cypher = EOSIO.getCypher(model.priKey, password: model.password) {
                            let currency = Currency(id: nil,
                                                    type: .EOS,
                                                    cipher: cypher,
                                                    pubKey: pubkey,
                                                    wid: walletId,
                                                    date: date,
                                                    address: nil)
                            let _ = try WalletCacheService.shared.insertCurrency(currency)
                            Defaults[.currentWalletID] = walletId.string
                        }
                    }

                    if model.currencySetting.contains(.ETH) {

                    }

                    success()
                }
            } catch {
                failed(R.string.localizable.wallet_create_failed.key.localized())
            }
        }
    }

    func setWalletPin(_ password: String,
                      failed: @escaping FailedComplication) {
        BLTWalletIO.shareInstance().initPin(password, failed: failed)
    }

    func updatePin(_ new: String, success: @escaping SuccessedComplication, failed: @escaping FailedComplication) {
        BLTWalletIO.shareInstance()?.updatePin(new, success: success, failed: failed)
        waitPowerOn(self.rootVC, promate: R.string.localizable.wookong_power_change_pas.key.localized(), retry: {
            BLTWalletIO.shareInstance()?.updatePin(new, success: success, failed: failed)
        }) {}
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
