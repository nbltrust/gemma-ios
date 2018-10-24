//
//  LeadInKeyCoordinator.swift
//  EOS
//
//  Created DKM on 2018/7/31.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift
import eos_ios_core_cpp

protocol LeadInKeyCoordinatorProtocol {
    func openScan()

    func openSetWallet()
}

protocol LeadInKeyStateManagerProtocol {
    var state: LeadInKeyState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<LeadInKeyState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState

    func validPrivateKey(_ privKey: String) -> (Bool, String)
    func importPrivKey(_ privKey: String)
}

class LeadInKeyCoordinator: NavCoordinator {

    lazy var creator = LeadInKeyPropertyActionCreate()

    var store = Store<LeadInKeyState>(
        reducer: gLeadInKeyReducer,
        state: nil,
        middleware: [trackingMiddleware]
    )
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

    func openSetWallet() {
        if let vc = R.storyboard.leadIn.setWalletViewController() {
            let coordinator = SetWalletCoordinator(rootVC: self.rootVC)
            vc.coordinator = coordinator
            vc.settingType = .leadIn
            self.rootVC.pushViewController(vc, animated: true)
        }
    }
}

extension LeadInKeyCoordinator: LeadInKeyStateManagerProtocol {
    var state: LeadInKeyState {
        return store.state
    }

    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<LeadInKeyState>) -> Subscription<SelectedState>)?
        ) where S.StoreSubscriberStateType == SelectedState {
        store.subscribe(subscriber, transform: transform)
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
