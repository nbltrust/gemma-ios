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

    func validForm(_ password: String, confirmPassword: String, hint: String) -> (Bool, String)

    func importPriKeyWallet(_ name: String, priKey: String, type: CurrencyType, password: String, hint: String)

    func importMnemonicWallet(_ name: String, mnemonic: String, password: String, hint: String)

    func updatePassword(_ password: String, hint: String)

    func validName(_ valid: Bool)

    func validPassword(_ valid: Bool)

    func validComfirmPassword(_ valid: Bool)

    func checkAgree(_ agree: Bool)

    func setWalletPin(_ password: String, success: @escaping () -> Void, failed: @escaping (String?) -> Void)
    
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

    func validForm(_ password: String, confirmPassword: String, hint: String) -> (Bool, String) {
        return (true, "")
    }

    func importPriKeyWallet(_ name: String, priKey: String, type: CurrencyType, password: String, hint: String) {
        do {
            let date = Date.init()
            let wallets = try WalletCacheService.shared.fetchAllWallet()
            let idNum: Int64 = Int64(wallets!.count) + 1
            let wallet = Wallet(id: nil, name: name, type: .HD, cipher: "", deviceName: nil, date: date)
            let pubkey = EOSIO.getPublicKey(priKey)
            let currency = Currency(id: nil, type: type, cipher: "", pubKey: pubkey!, wid: idNum, date: date, address: nil)
            let id = try WalletCacheService.shared.createWallet(wallet: wallet, currencys: [currency])
            Defaults[.currentWalletID] = (id?.string)!
            if let _ = self.rootVC.viewControllers[0] as? EntryGuideViewController {
                self.dismissCurrentNav(self.rootVC.viewControllers[1])
            } else {
                self.rootVC.popToRootViewController(animated: true)
            }
        } catch {
            showFailTop("数据库存储失败")
        }
    }

    func importMnemonicWallet(_ name: String, mnemonic: String, password: String, hint: String) {

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

    func setWalletPin(_ password: String, success: @escaping () -> Void, failed: @escaping (String?) -> Void) {
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
