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

protocol EntryCoordinatorProtocol {
    func pushToServiceProtocolVC()
    func pushToGetInviteCodeIntroductionVC()
    func pushToCreateSuccessVC()
}

protocol EntryStateManagerProtocol {
    var state: EntryState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<EntryState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState
    
    func validWalletName(_ name: String)
    func validPassword(_ password: String)
    func validComfirmPassword(_ password: String, comfirmPassword: String)
    func validInviteCode(_ code: String)
    func checkAgree(_ agree: Bool)
    func createWallet(_ walletName: String, password: String, prompt: String, inviteCode: String, completion:@escaping (Bool)->())
}

class EntryCoordinator: EntryRootCoordinator {
    
    lazy var creator = EntryPropertyActionCreate()
    
    var store = Store<EntryState>(
        reducer: EntryReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
}

extension EntryCoordinator: EntryCoordinatorProtocol {
    func pushToServiceProtocolVC() {
        let vc = BaseWebViewController()
        vc.url = H5AddressConfiguration.REGISTER_PROTOCOL_URL
        vc.title = R.string.localizable.service_protocol()
        self.rootVC.pushViewController(vc, animated: true)
    }
    
    func pushToGetInviteCodeIntroductionVC() {
        let vc = BaseWebViewController()
        vc.url = H5AddressConfiguration.GET_INVITECODE_URL
        vc.title = R.string.localizable.invitationcode_introduce()
        self.rootVC.pushViewController(vc, animated: true)
    }
    
    func pushToCreateSuccessVC() {
        let createCompleteVC = R.storyboard.entry.creatationCompleteViewController()
        let coordinator = CreatationCompleteCoordinator(rootVC: self.rootVC)
        createCompleteVC?.coordinator = coordinator
        self.rootVC.pushViewController(createCompleteVC!, animated: true)
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
    
    func validWalletName(_ name: String) {
        self.store.dispatch(nameAction(isValid: WallketManager.shared.isValidWalletName(name)))
    }
    
    func validPassword(_ password: String) {
        self.store.dispatch(passwordAction(isValid: WallketManager.shared.isValidPassword(password)))
    }
    
    func validComfirmPassword(_ password: String, comfirmPassword: String) {
        self.store.dispatch(comfirmPasswordAction(isValid: WallketManager.shared.isValidComfirmPassword(password, comfirmPassword: comfirmPassword)))
    }
    
    func validInviteCode(_ code: String) {
        self.store.dispatch(inviteCodeAction(isValid: !code.isEmpty))
    }
    
    func checkAgree(_ agree: Bool) {
        self.store.dispatch(agreeAction(isAgree: agree))
    }
    
    func createWallet(_ walletName: String, password: String, prompt: String, inviteCode: String, completion: @escaping (Bool) -> ()) {
        NBLNetwork.request(target: .createAccount(account: walletName, pubKey: WallketManager.shared.pubKey, invitationCode: inviteCode), success: { (data) in
            WallketManager.shared.saveWallket(walletName, password: password, hint: prompt)
            self.pushToCreateSuccessVC()
        }, error: { (code) in
            if let gemmaerror = GemmaError.NBLNetworkErrorCode(rawValue: code) {
                let error = GemmaError.NBLCode(code: gemmaerror)
                KRProgressHUD.showError(withMessage: error.localizedDescription)
            } else {
                KRProgressHUD.showError(withMessage: R.string.localizable.error_unknow())
            }
        }) { (error) in
            KRProgressHUD.showError(withMessage: R.string.localizable.request_failed())
        }
    }
}
