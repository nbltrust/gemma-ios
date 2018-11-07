//
//  LeadInMnemonicCoordinator.swift
//  EOS
//
//  Created peng zhu on 2018/10/30.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift
import NBLCommonModule

protocol LeadInMnemonicCoordinatorProtocol {
    func openSetWallet(_ mnemonic: String)
}

protocol LeadInMnemonicStateManagerProtocol {
    var state: LeadInMnemonicState { get }
    
    func switchPageState(_ state:PageState)

    func validMnemonic(_ mnemonic: String) -> Bool
}

class LeadInMnemonicCoordinator: NavCoordinator {
    var store = Store(
        reducer: gLeadInMnemonicReducer,
        state: nil,
        middleware:[trackingMiddleware]
    )
    
    var state: LeadInMnemonicState {
        return store.state
    }
    
    override class func start(_ root: BaseNavigationController, context: RouteContext? = nil) -> BaseViewController {
        let selfVC = R.storyboard.leadIn.leadInMnemonicViewController()!
        let coordinator = LeadInMnemonicCoordinator(rootVC: root)
        selfVC.coordinator = coordinator
        coordinator.store.dispatch(RouteContextAction(context: context))
        return selfVC
    }

    override func register() {
        Broadcaster.register(LeadInMnemonicCoordinatorProtocol.self, observer: self)
        Broadcaster.register(LeadInMnemonicStateManagerProtocol.self, observer: self)
    }
}

extension LeadInMnemonicCoordinator: LeadInMnemonicCoordinatorProtocol {
    func openSetWallet(_ mnemonic: String) {
        if let setVC = R.storyboard.leadIn.setWalletViewController() {
            let coordinator = SetWalletCoordinator(rootVC: self.rootVC)
            setVC.coordinator = coordinator
            setVC.settingType = .leadInWithMnemonic
            setVC.mnemonicStr = mnemonic
            self.rootVC.pushViewController(setVC, animated: true)
        }
    }
}

extension LeadInMnemonicCoordinator: LeadInMnemonicStateManagerProtocol {
    func switchPageState(_ state:PageState) {
        DispatchQueue.main.async {
            self.store.dispatch(PageStateAction(state: state))
        }
    }

    func validMnemonic(_ mnemonic: String) -> Bool {
        return true
    }
}
