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

protocol SetWalletCoordinatorProtocol {

    func pushToServiceProtocolVC()

    func importFinished()

    func pushToSetAccountVC(_ hint: String)
}

protocol SetWalletStateManagerProtocol {
    var state: SetWalletState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<SetWalletState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState

    func validForm(_ password: String, confirmPassword: String, hint: String) -> (Bool, String)

    func importLocalWallet(_ password: String, hint: String, completion: @escaping (Bool) -> Void)

    func updatePassword(_ password: String, hint: String)

    func validPassword(_ password: String)

    func validComfirmPassword(_ password: String, comfirmPassword: String)

    func checkAgree(_ agree: Bool)

    func setWalletPin(_ password: String, success: @escaping () -> Void, failed: @escaping (String?) -> Void)
}

class SetWalletCoordinator: NavCoordinator {

    lazy var creator = SetWalletPropertyActionCreate()

    var store = Store<SetWalletState>(
        reducer: SetWalletReducer,
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
        let vc = BaseWebViewController()
        vc.url = H5AddressConfiguration.RegisterProtocolURL
        vc.title = R.string.localizable.service_protocol.key.localized()
        self.rootVC.pushViewController(vc, animated: true)
    }

    func importFinished() {
        let count = self.rootVC.viewControllers.count
        if count - 3 > 0, let vc = self.rootVC.viewControllers[count - 3] as? LeadInViewController {
            vc.coordinator?.state.callback.fadeCallback.value?()
        }
    }

    func pushToSetAccountVC(_ hint: String) {
        let vc = R.storyboard.entry.entryViewController()
        vc?.createType = .wookong
        vc?.hint = hint
        let accountCoordinator = EntryCoordinator(rootVC: self.rootVC)
        vc?.coordinator = accountCoordinator
        self.rootVC.pushViewController(vc!, animated: true)
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

    func validForm(_ password: String, confirmPassword: String, hint: String) -> (Bool, String) {
        return (true, "")
    }

    func importLocalWallet(_ password: String, hint: String, completion: @escaping (Bool) -> Void) {
        WalletManager.shared.importPrivateKey(password, hint: hint, completion: completion)
    }

    func updatePassword(_ password: String, hint: String) {
        WalletManager.shared.updateWalletPassword(password, hint: hint)
        self.rootVC.popViewController()
    }

    func validPassword(_ password: String) {
        self.store.dispatch(SetWalletPasswordAction(isValid: WalletManager.shared.isValidPassword(password)))
    }

    func validComfirmPassword(_ password: String, comfirmPassword: String) {
        self.store.dispatch(SetWalletComfirmPasswordAction(isValid: WalletManager.shared.isValidComfirmPassword(password, comfirmPassword: comfirmPassword)))
    }

    func checkAgree(_ agree: Bool) {
        self.store.dispatch(SetWalletAgreeAction(isAgree: agree))
    }

    func setWalletPin(_ password: String, success: @escaping () -> Void, failed: @escaping (String?) -> Void) {
        BLTWalletIO.shareInstance().initPin(password, success: success, failed: failed)
    }

}
