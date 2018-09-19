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
import SwiftNotificationCenter

protocol EntryCoordinatorProtocol {
    func pushToServiceProtocolVC()
    func pushToCreateSuccessVC()
    func pushToActivateVC()
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
    func createWallet(_ walletName: String, password: String, prompt: String, inviteCode: String, completion:@escaping (Bool)->())
    func verifyAccount(_ name: String, completion: @escaping (Bool) -> ())
}

class EntryCoordinator: EntryRootCoordinator {
    
    lazy var creator = EntryPropertyActionCreate()
    
    var store = Store<EntryState>(
        reducer: EntryReducer,
        state: nil,
        middleware:[TrackingMiddleware]
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
    
    func verifyAccount(_ name: String, completion: @escaping (Bool) -> ()) {
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
        }) { (error) in
            completion(false)
            showFailTop(R.string.localizable.request_failed.key.localized())
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
    
    func createWallet(_ walletName: String, password: String, prompt: String, inviteCode: String, completion: @escaping (Bool) -> ()) {
        self.rootVC.topViewController?.startLoading()
        NBLNetwork.request(target: .createAccount(account: walletName, pubKey: WalletManager.shared.currentPubKey, invitationCode: inviteCode, hash: ""), success: { (data) in
            self.rootVC.topViewController?.endLoading()
            WalletManager.shared.saveWallket(walletName, password: password, hint: prompt, isImport: false, txID: data["txId"].stringValue, invitationCode:inviteCode)
            self.pushToCreateSuccessVC()
        }, error: { (code) in
            if let gemmaerror = GemmaError.NBLNetworkErrorCode(rawValue: code) {
                let error = GemmaError.NBLCode(code: gemmaerror)
                showFailTop(error.localizedDescription)
            } else {
                showFailTop(R.string.localizable.error_unknow.key.localized())
            }
        }) { (error) in
            showFailTop(R.string.localizable.request_failed.key.localized())
        }
    }
}
