//
//  EntryCoordinator.swift
//  EOS
//
//  Created koofrank on 2018/7/4.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift
import KRProgressHUD
import NBLCommonModule
import seed39_ios_golang
import eos_ios_core_cpp
import SwiftyUserDefaults
import Seed39

protocol EntryCoordinatorProtocol {
    func pushToServiceProtocolVC()
    func pushToCreateSuccessVC()
    func pushToActivateVCWithCurrencyID(_ id: Int64?)
    func pushBackupPrivateKeyVC()
    func dismissCurrentNav(_ entry: UIViewController?)
    func pushBackupMnemonicVC()
    func popToRootVC()
}

protocol EntryStateManagerProtocol {
    var state: EntryState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<EntryState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState

    func validAccountName(_ name: String)

    func validWalletName(_ name: String)

    func validPassword(_ password: String)

    func validComfirmPassword(_ password: String, comfirmPassword: String)

    func checkAgree(_ agree: Bool)

    func createEOSAccount(_ type: CreateAPPId,
                          goodsId: GoodsId,
                          accountName: String,
                          currencyID: Int64?,
                          inviteCode: String,
                          validation: WookongValidation?,
                          completion: @escaping (Bool) -> Void)

    func copyMnemonicWord()

    func getValidation(_ success: @escaping GetVolidationComplication, failed: @escaping FailedComplication)

    func verifyAccount(_ name: String, completion: @escaping (Bool) -> Void)

    func createBLTWallet(_ name: String, currencyID: Int64?, completion:@escaping (Bool)-> Void)

    func createTempWallet(_ pwd: String, prompt: String, type: WalletType)

    func createNewWallet(walletName: String, pwd: String, checkStr: String, deviceName: String?, prompt: String?)
}

class EntryCoordinator: NavCoordinator {

    lazy var creator = EntryPropertyActionCreate()

    var store = Store<EntryState>(
        reducer: gEntryReducer,
        state: nil,
        middleware: [trackingMiddleware]
    )

    override func register() {
        Broadcaster.register(EntryCoordinatorProtocol.self, observer: self)
        Broadcaster.register(EntryStateManagerProtocol.self, observer: self)
    }
}

extension EntryCoordinator: EntryCoordinatorProtocol {
    func pushToServiceProtocolVC() {
        let vc = BaseWebViewController()
        vc.url = H5AddressConfiguration.RegisterProtocolURL
        vc.title = R.string.localizable.service_protocol.key.localized()
        self.rootVC.pushViewController(vc, animated: true)
    }

    func pushToCreateSuccessVC() {
        let createCompleteVC = R.storyboard.entry.creatationCompleteViewController()
        let coordinator = CreatationCompleteCoordinator(rootVC: self.rootVC)
        createCompleteVC?.coordinator = coordinator
        self.rootVC.pushViewController(createCompleteVC!, animated: true)
    }

    func pushToActivateVCWithCurrencyID(_ id: Int64?) {
        let copyVC = ActivateViewController()
        let copyCoordinator = ActivateCoordinator(rootVC: self.rootVC)
        copyVC.coordinator = copyCoordinator
        copyVC.currencyID = id
        self.rootVC.pushViewController(copyVC, animated: true)
    }

    func pushBackupPrivateKeyVC() {
        let vc = R.storyboard.entry.backupPrivateKeyViewController()!
        let coor = BackupPrivateKeyCoordinator(rootVC: self.rootVC)

        if let entry = self.rootVC.viewControllers[self.rootVC.viewControllers.count - 2] as? EntryViewController {
            coor.state.callback.hadSaveCallback.accept {[weak self] in
                guard let `self` = self else { return }
                self.dismissCurrentNav(entry)
            }
        }
        if let entry = self.rootVC.viewControllers[self.rootVC.viewControllers.count - 3] as? EntryViewController {
            coor.state.callback.hadSaveCallback.accept {[weak self] in
                guard let `self` = self else { return }
                self.dismissCurrentNav(entry)
            }
        }

        vc.coordinator = coor
        self.rootVC.pushViewController(vc, animated: true)
    }

    func dismissCurrentNav(_ entry: UIViewController? = nil) {
        if let entry = entry as? EntryViewController {
            entry.coordinator?.state.callback.endCallback.value?()
            return
        }
        if let vc = self.rootVC.viewControllers[self.rootVC.viewControllers.count - 2] as? EntryViewController {
            vc.coordinator?.state.callback.endCallback.value?()
        }
    }

    func pushBackupMnemonicVC() {
        let vc = R.storyboard.mnemonic.backupMnemonicWordViewController()!
        let coor = BackupMnemonicWordCoordinator(rootVC: self.rootVC)
        vc.coordinator = coor
        self.rootVC.pushViewController(vc, animated: true)
    }

    func popToRootVC() {
        self.rootVC.popToRootViewController(animated: true)
    }
}

extension EntryCoordinator: EntryStateManagerProtocol {
    var state: EntryState {
        return store.state
    }

    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<EntryState>) -> Subscription<SelectedState>)?
        ) where S.StoreSubscriberStateType == SelectedState {
        store.subscribe(subscriber, transform: transform)
    }

    func verifyAccount(_ name: String, completion: @escaping (Bool) -> Void) {
        self.rootVC.topViewController?.startLoading()
        NBLNetwork.request(target: .accountVerify(account: name), success: { (data) in
            self.rootVC.topViewController?.endLoading()
            if data["valid"].boolValue == false {
                completion(true)
            } else {
                showFailTop(R.string.localizable.error_account_registered.key.localized())
                completion(false)
            }
        }, error: { (code) in
            if let gemmaerror = GemmaError.NBLNetworkErrorCode(rawValue: code) {
                let error = GemmaError.NBLCode(code: gemmaerror)
                showFailTop(error.localizedDescription)
            } else {
                showFailTop(R.string.localizable.error_unknow.key.localized())
            }
            completion(false)
        }) { (_) in
            completion(false)
        }
    }

    func validAccountName(_ name: String) {
        self.store.dispatch(NameAction(isValid: WalletManager.shared.isValidAccountName(name)))
    }
    func validWalletName(_ name: String) {
        self.store.dispatch(WalletNameAction(isValid: true))
    }

    func validPassword(_ password: String) {
        self.store.dispatch(PasswordAction(isValid: WalletManager.shared.isValidPassword(password)))
    }

    func validComfirmPassword(_ password: String, comfirmPassword: String) {
        self.store.dispatch(ComfirmPasswordAction(isValid: WalletManager.shared.isValidComfirmPassword(password, comfirmPassword: comfirmPassword)))
    }

    func checkAgree(_ agree: Bool) {
        self.store.dispatch(AgreeAction(isAgree: agree))
    }

    func createEOSAccount(_ type: CreateAPPId,
                          goodsId: GoodsId,
                          accountName: String,
                          currencyID: Int64?,
                          inviteCode: String,
                          validation: WookongValidation?,
                          completion: @escaping (Bool) -> Void) {
        do {
            if let id = currencyID {
                let currency = try WalletCacheService.shared.fetchCurrencyBy(id: id)
                if type == .bluetooth {
                    if var currency = currency, let publicKey = validation?.publicKey {
                        currency.pubKey = publicKey
                        try WalletCacheService.shared.updateCurrency(currency)
                    }
                }
                if let pubkey = currency?.pubKey {
                    NBLNetwork.request(target: .createAccount(type: type,
                                                              goodsId: goodsId,
                                                              account: accountName,
                                                              pubKey: pubkey,
                                                              invitationCode: inviteCode,
                                                              validation: validation),
                                       success: { (data) in
                                        CurrencyManager.shared.saveActived(id, actived: .actived)
                                        CurrencyManager.shared.saveAccountNameWith(id, name: accountName)
                                        self.rootVC.popToRootViewController(animated: true)
                                        completion(true)
                    }, error: { (code) in
                        if let gemmaerror = GemmaError.NBLNetworkErrorCode(rawValue: code) {
                            let error = GemmaError.NBLCode(code: gemmaerror)
                            showFailTop(error.localizedDescription)
                        } else {
                            showFailTop(R.string.localizable.error_unknow.key.localized())
                        }
                        completion(false)
                    }) { (_) in
                        completion(false)
                    }
                }
            }
        } catch {

        }
    }

    func getValidation(_ success: @escaping GetVolidationComplication, failed: @escaping FailedComplication) {
        BLTWalletIO.shareInstance()?.getVolidation(success, failed: failed)
    }

    func copyMnemonicWord() {
        let mnemonicWordVC = R.storyboard.mnemonic.backupMnemonicWordViewController()
        let coor = BackupMnemonicWordCoordinator(rootVC: self.rootVC)
        mnemonicWordVC?.coordinator = coor
        self.rootVC.pushViewController(mnemonicWordVC!, animated: true)
    }

    func createBLTWallet(_ name: String, currencyID: Int64?, completion:@escaping (Bool)-> Void) {
        BLTWalletIO.shareInstance()?.getVolidation({ [weak self] (sn, snSig, pub, pubSig, publicKey) in
            guard let `self` = self else { return }
            var validation = WookongValidation()
            validation.SN = sn ?? ""
            validation.SNSig = snSig ?? ""
            validation.pubKey = pub ?? ""
            validation.publicKeySig = pubSig ?? ""
            validation.publicKey = publicKey ?? ""
            self.createEOSAccount(.bluetooth, goodsId: .sn, accountName: name, currencyID: currencyID, inviteCode: "", validation: validation, completion: { (successed) in
                completion(successed)
                if successed {
                    self.popToRootVC()
                }
            })
            }, failed: { (reason) in
                completion(false)
                if let failedReason = reason {
                    showFailTop(failedReason)
                }
        })
    }

    func createTempWallet(_ pwd: String, prompt: String, type: WalletType) {
        let model = WalletModel(pwd: pwd, prompt:prompt ,type: type)
        self.store.dispatch(WalletModelAction(model: model))
    }

    func createNewWallet(walletName: String, pwd: String, checkStr: String, deviceName: String?, prompt: String?) {
        do {
            let wallets = try WalletCacheService.shared.fetchAllWallet()
            let idNum: Int64 = Int64(wallets!.count) + 1
            let date = Date.init()
            let cipher = Seed39KeyEncrypt(pwd, checkStr)
            let wallet = Wallet(id: nil, name: walletName, type: .HD, cipher: cipher, deviceName: nil, date: date, hint: prompt)

            let seed = Seed39SeedByMnemonic(checkStr)
            let prikey = Seed39DeriveWIF(seed, CurrencyType.EOS.derivationPath, true)
            let curCipher = EOSIO.getCypher(prikey, password: pwd)
            let pubkey = EOSIO.getPublicKey(prikey)
            let currency = Currency(id: nil, type: .EOS, cipher: curCipher!, pubKey: pubkey!, wid: idNum, date: date, address: nil)

            let prikey2 = Seed39DeriveRaw(seed, CurrencyType.ETH.derivationPath)
            let curCipher2 = Seed39KeyEncrypt(pwd, prikey2)
            let address = Seed39GetEthereumAddressFromPrivateKey(prikey2)
            let currency2 = Currency(id: nil, type: .ETH, cipher: curCipher2!, pubKey: nil, wid: idNum, date: date, address: address)

            let id = try WalletCacheService.shared.createWallet(wallet: wallet, currencys: [currency,currency2])
            if let id = id {
                Defaults[.currentWalletID] = id.string
            }
        } catch {
            showFailTop("数据库存储失败")
        }
    }
}
