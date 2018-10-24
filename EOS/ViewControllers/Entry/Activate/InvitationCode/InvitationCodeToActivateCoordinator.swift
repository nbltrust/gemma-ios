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
import KRProgressHUD

protocol InvitationCodeToActivateCoordinatorProtocol {
    func pushToGetInviteCodeIntroductionVC()
    func pushToCreateSuccessVC()
    func pushBackupPrivateKeyVC()
    func dismissCurrentNav(_ entry: UIViewController?)
}

protocol InvitationCodeToActivateStateManagerProtocol {
    var state: InvitationCodeToActivateState { get }

    func switchPageState(_ state: PageState)

    func createWallet(_ inviteCode: String, completion: @escaping (Bool) -> Void)
}

class InvitationCodeToActivateCoordinator: NavCoordinator {
    var store = Store(
        reducer: InvitationCodeToActivateReducer,
        state: nil,
        middleware: [TrackingMiddleware]
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
}

extension InvitationCodeToActivateCoordinator: InvitationCodeToActivateStateManagerProtocol {
    func switchPageState(_ state: PageState) {
        DispatchQueue.main.async {
            self.store.dispatch(PageStateAction(state: state))
        }
    }

    func createWallet(_ inviteCode: String, completion: @escaping (Bool) -> Void) {
        self.rootVC.topViewController?.startLoading()
        var walletName = ""
        var password = ""
        var prompt = ""
        Broadcaster.notify(EntryViewController.self) { (vc) in
            walletName = vc.registerView.nameView.textField.text!
            password = vc.registerView.passwordView.textField.text!
            prompt = vc.registerView.passwordPromptView.textField.text!
        }

        NBLNetwork.request(target: .createAccount(type: .gemma, account: walletName, pubKey: WalletManager.shared.currentPubKey, invitationCode: inviteCode, validation: nil), success: { (data) in
            KRProgressHUD.showSuccess()
            WalletManager.shared.saveWallket(walletName, password: password, hint: prompt, isImport: false, txID: data["txId"].stringValue, invitationCode: inviteCode)
            self.pushBackupPrivateKeyVC()
        }, error: { (code) in
            if let gemmaerror = GemmaError.NBLNetworkErrorCode(rawValue: code) {
                let error = GemmaError.NBLCode(code: gemmaerror)
                showFailTop(error.localizedDescription)
            } else {
                showFailTop(R.string.localizable.error_unknow.key.localized())
            }
        }) { (_) in
        }
    }
}
