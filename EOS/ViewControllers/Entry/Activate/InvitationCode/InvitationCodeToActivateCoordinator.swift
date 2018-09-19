//
//  InvitationCodeToActivateCoordinator.swift
//  EOS
//
//  Created zhusongyu on 2018/9/6.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift
import NBLCommonModule
import Async
import KRProgressHUD

protocol InvitationCodeToActivateCoordinatorProtocol {
    func pushToGetInviteCodeIntroductionVC()
    func pushToCreateSuccessVC() 
}

protocol InvitationCodeToActivateStateManagerProtocol {
    var state: InvitationCodeToActivateState { get }
    
    func switchPageState(_ state:PageState)
    
    func createWallet(_ inviteCode: String, completion: @escaping (Bool) -> ())
}

class InvitationCodeToActivateCoordinator: EntryRootCoordinator {
    var store = Store(
        reducer: InvitationCodeToActivateReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
    
    var state: InvitationCodeToActivateState {
        return store.state
    }
            
    override func register() {
        Broadcaster.register(InvitationCodeToActivateCoordinatorProtocol.self, observer: self)
        Broadcaster.register(InvitationCodeToActivateStateManagerProtocol.self, observer: self)
    }
}

extension InvitationCodeToActivateCoordinator: InvitationCodeToActivateCoordinatorProtocol {
    func pushToGetInviteCodeIntroductionVC() {
        let vc = BaseWebViewController()
        vc.url = H5AddressConfiguration.GET_INVITECODE_URL
        vc.title = R.string.localizable.invitationcode_introduce.key.localized()
        self.rootVC.pushViewController(vc, animated: true)
    }
    
    func pushToCreateSuccessVC() {
        let createCompleteVC = R.storyboard.entry.creatationCompleteViewController()
        let coordinator = CreatationCompleteCoordinator(rootVC: self.rootVC)
        createCompleteVC?.coordinator = coordinator
        self.rootVC.pushViewController(createCompleteVC!, animated: true)
    }
}

extension InvitationCodeToActivateCoordinator: InvitationCodeToActivateStateManagerProtocol {
    func switchPageState(_ state:PageState) {
        Async.main {
            self.store.dispatch(PageStateAction(state: state))
        }
    }
    
    func createWallet(_ inviteCode: String, completion: @escaping (Bool) -> ()) {
        self.rootVC.topViewController?.startLoading()
        var walletName = ""
        var password = ""
        var prompt = ""
        Broadcaster.notify(EntryViewController.self) { (vc) in
            walletName = vc.registerView.nameView.textField.text!
            password = vc.registerView.passwordView.textField.text!
            prompt = vc.registerView.passwordPromptView.textField.text!
        }
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
