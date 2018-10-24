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

protocol EntryCoordinatorProtocol {
    func pushToServiceProtocolVC()
    func pushToCreateSuccessVC()
    func pushToActivateVC()
    func pushBackupPrivateKeyVC()
    func presentSetFingerPrinterVC()
    func dismissCurrentNav(_ entry: UIViewController?)
}

protocol EntryStateManagerProtocol {
    var state: EntryState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<EntryState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState

    func validWalletName(_ name: String)

    func validPassword(_ password: String)

    func validComfirmPassword(_ password: String, comfirmPassword: String)

    func checkAgree(_ agree: Bool)

    func createWallet(_ type: CreateAPPId, accountName: String, password: String, prompt: String, inviteCode: String, validation: WookongValidation?, deviceName: String?, completion:@escaping (Bool) -> Void)

    func copyMnemonicWord()

    func getValidation(_ success: @escaping GetVolidationComplication, failed: @escaping FailedComplication)

    func checkSeedSuccessed()

    func verifyAccount(_ name: String, completion: @escaping (Bool) -> Void)

    func createWallet(_ name: String, completion:@escaping (Bool) -> Void)
}

class EntryCoordinator: NavCoordinator {

    lazy var creator = EntryPropertyActionCreate()

    var store = Store<EntryState>(
        reducer: EntryReducer,
        state: nil,
        middleware: [TrackingMiddleware]
    )

    override func register() {
        Broadcaster.register(EntryCoordinatorProtocol.self, observer: self)
        Broadcaster.register(EntryStateManagerProtocol.self, observer: self)
    }
}

extension EntryCoordinator: EntryCoordinatorProtocol {
    func pushToServiceProtocolVC() {
        let vc = BaseWebViewController()
        vc.url = H5AddressConfiguration.REGISTER_PROTOCOL_URL
        vc.title = R.string.localizable.service_protocol.key.localized()
        self.rootVC.pushViewController(vc, animated: true)
    }

    func pushToCreateSuccessVC() {
        let createCompleteVC = R.storyboard.entry.creatationCompleteViewController()
        let coordinator = CreatationCompleteCoordinator(rootVC: self.rootVC)
        createCompleteVC?.coordinator = coordinator
        self.rootVC.pushViewController(createCompleteVC!, animated: true)
    }

    func pushToActivateVC() {
        let copyVC = ActivateViewController()
        let copyCoordinator = ActivateCoordinator(rootVC: self.rootVC)
        copyVC.coordinator = copyCoordinator
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

    func presentSetFingerPrinterVC() {
        let printerVC = R.storyboard.bltCard.bltCardSetFingerPrinterViewController()!
        let nav = BaseNavigationController.init(rootViewController: printerVC)
        let coor = BLTCardSetFingerPrinterCoordinator(rootVC: nav)
        printerVC.coordinator = coor
        self.rootVC.present(nav, animated: true) {
            self.rootVC.popToRootViewController(animated: true)
        }
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

    func validWalletName(_ name: String) {
        self.store.dispatch(nameAction(isValid: WalletManager.shared.isValidWalletName(name)))
    }

    func validPassword(_ password: String) {
        self.store.dispatch(passwordAction(isValid: WalletManager.shared.isValidPassword(password)))
    }

    func validComfirmPassword(_ password: String, comfirmPassword: String) {
        self.store.dispatch(comfirmPasswordAction(isValid: WalletManager.shared.isValidComfirmPassword(password, comfirmPassword: comfirmPassword)))
    }

    func checkAgree(_ agree: Bool) {
        self.store.dispatch(agreeAction(isAgree: agree))
    }

    func createWallet(_ type: CreateAPPId, accountName: String, password: String, prompt: String, inviteCode: String, validation: WookongValidation?, deviceName: String?, completion: @escaping (Bool) -> Void) {
        NBLNetwork.request(target: .createAccount(type: type, account: accountName, pubKey: WalletManager.shared.currentPubKey, invitationCode: inviteCode, validation: validation), success: { (data) in
            WalletManager.shared.currentPubKey = validation?.publicKey ?? ""
            WalletManager.shared.saveWallket(accountName, password: password, hint: prompt, isImport: false, txID: data["txId"].stringValue, invitationCode: inviteCode, type: type, deviceName: deviceName)
            self.pushBackupPrivateKeyVC()
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

    func getValidation(_ success: @escaping GetVolidationComplication, failed: @escaping FailedComplication) {
        BLTWalletIO.shareInstance()?.getVolidation(success, failed: failed)
    }

    func copyMnemonicWord() {
        let mnemonicWordVC = R.storyboard.mnemonic.backupMnemonicWordViewController()
        let coor = BackupMnemonicWordCoordinator(rootVC: self.rootVC)
        mnemonicWordVC?.coordinator = coor
        self.rootVC.pushViewController(mnemonicWordVC!, animated: true)
    }

    func checkSeedSuccessed() {
        self.store.dispatch(SetCheckSeedSuccessedAction(isCheck: true))
    }

    func createWallet(_ name: String, completion: @escaping (Bool) -> Void) {
        if let device = BLTWalletIO.shareInstance()?.selectDevice {
            BLTWalletIO.shareInstance()?.getVolidation({ [weak self] (sn, sn_sig, pub, pub_sig, publicKey) in
                guard let `self` = self else { return }
                var validation = WookongValidation()
                validation.SN = sn ?? ""
                validation.SN_sig = sn_sig ?? ""
                validation.public_key = pub ?? ""
                validation.public_key_sig = pub_sig ?? ""
                validation.publicKey = publicKey ?? ""
                self.createWallet(.bluetooth, accountName: name, password: "", prompt: "", inviteCode: "", validation: validation, deviceName: device.name, completion: { (successed) in
                    completion(successed)
                    if successed {
                        self.presentSetFingerPrinterVC()
                    }
                })
                }, failed: { (reason) in
                    completion(false)
                    if let failedReason = reason {
                        showFailTop(failedReason)
                    }
            })
        } else {
            completion(false)
        }
    }
}
