//
//  LeadInKeyCoordinator.swift
//  EOS
//
//  Created peng zhu on 2018/11/2.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift
import NBLCommonModule
import eos_ios_core_cpp

protocol LeadInKeyCoordinatorProtocol {
    func openScan()

    func openSetWallet(_ priKey: String)

    func pushToWalletSelectVC()

    func pushToCurrencyVC()
}

protocol LeadInKeyStateManagerProtocol {
    var state: LeadInKeyState { get }
    
    func switchPageState(_ state:PageState)

    func validPrivateKey(_ privKey: String) -> (Bool, String)

    func importPrivKey(_ privKey: String)
}

class LeadInKeyCoordinator: NavCoordinator {
    var store = Store(
        reducer: gLeadInKeyReducer,
        state: nil,
        middleware:[trackingMiddleware]
    )
    
    var state: LeadInKeyState {
        return store.state
    }
    
    override class func start(_ root: BaseNavigationController, context:RouteContext? = nil) -> BaseViewController {
        let vc = R.storyboard.leadIn.leadInKeyViewController()!
        let coordinator = LeadInKeyCoordinator(rootVC: root)
        vc.coordinator = coordinator
        coordinator.store.dispatch(RouteContextAction(context: context))
        return vc
    }

    override func register() {
        Broadcaster.register(LeadInKeyCoordinatorProtocol.self, observer: self)
        Broadcaster.register(LeadInKeyStateManagerProtocol.self, observer: self)
    }
}

extension LeadInKeyCoordinator: LeadInKeyCoordinatorProtocol {
    func openScan() {
        let context = ScanContext()
        context.scanResult.accept { (result) in
            if let leadInVC = self.rootVC.topViewController as? LeadInKeyViewController {
                leadInVC.leadInKeyView.textView.text = result
            }
        }

        presentVC(ScanCoordinator.self, context: context, navSetup: { (nav) in
            nav.navStyle = .clear
        }, presentSetup: nil)
    }

    func openSetWallet(_ priKey: String) {
        if let setVC = R.storyboard.leadIn.setWalletViewController() {
            let coordinator = SetWalletCoordinator(rootVC: self.rootVC)
            setVC.coordinator = coordinator
            setVC.settingType = .leadInWithPriKey
            setVC.priKey = priKey
            setVC.currencyType = self.state.currencyType.value ?? .EOS
            self.rootVC.pushViewController(setVC, animated: true)
        }
    }

    func pushToCurrencyVC() {
        var context = CurrencyListContext()
        context.currencySelectResult.accept {[weak self] (currencyType) in
            guard let `self` = self else { return }
            self.state.currencyType.accept(currencyType)
        }
        context.selectedCurrency = self.state.currencyType.value ?? .EOS

        pushVC(CurrencyListCoordinator.self, animated: true, context: context)
    }

    func pushToWalletSelectVC() {
        var context = WalletSelectListContext()
        context.walletSelectResult.accept {[weak self] (wallet) in
            guard let `self` = self else { return }
            self.state.toWallet.accept(wallet)
        }
        context.chooseNewWalletResult.accept { [weak self] in
            guard let `self` = self else { return }
            self.state.toWallet.accept(nil)
        }
        context.selectedWallet = self.state.toWallet.value ?? nil

        pushVC(CurrencyListCoordinator.self, animated: true, context: context)
    }
}

extension LeadInKeyCoordinator: LeadInKeyStateManagerProtocol {
    func switchPageState(_ state:PageState) {
        DispatchQueue.main.async {
            self.store.dispatch(PageStateAction(state: state))
        }
    }

    func validPrivateKey(_ privKey: String) -> (Bool, String) {
        if let _ = EOSIO.getPublicKey(privKey) {
            return (true, "")
        } else {
            self.rootVC.showError(message: R.string.localizable.privatekey_faile.key.localized())
            return (false, "")
        }
    }

    func importPrivKey(_ privKey: String) {
        WalletManager.shared.addPrivatekey(privKey)
    }
}
