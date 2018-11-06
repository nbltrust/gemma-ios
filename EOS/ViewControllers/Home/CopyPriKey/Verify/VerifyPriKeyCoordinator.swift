//
//  VerifyPriKeyCoordinator.swift
//  EOS
//
//  Created zhusongyu on 2018/9/25.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift
import NBLCommonModule
import eos_ios_core_cpp

protocol VerifyPriKeyCoordinatorProtocol {
    func finishCopy()
}

protocol VerifyPriKeyStateManagerProtocol {
    var state: VerifyPriKeyState { get }

    func switchPageState(_ state: PageState)
}

class VerifyPriKeyCoordinator: NavCoordinator {
    var store = Store(
        reducer: gVerifyPriKeyReducer,
        state: nil,
        middleware: [trackingMiddleware]
    )

    var state: VerifyPriKeyState {
        return store.state
    }

    override func register() {
        Broadcaster.register(VerifyPriKeyCoordinatorProtocol.self, observer: self)
        Broadcaster.register(VerifyPriKeyStateManagerProtocol.self, observer: self)
    }

    override class func start(_ root: BaseNavigationController, context: RouteContext? = nil) -> BaseViewController {
        let vc = R.storyboard.home.verifyPriKeyViewController()!
        let coordinator = VerifyPriKeyCoordinator(rootVC: root)
        vc.coordinator = coordinator
        coordinator.store.dispatch(RouteContextAction(context: context))
        return vc
    }

}

extension VerifyPriKeyCoordinator: VerifyPriKeyCoordinatorProtocol {
    func finishCopy() {
        if let wallet = WalletManager.shared.currentWallet() {
            WalletManager.shared.backupSuccess(wallet)
        }
        if let lastVC = self.rootVC.viewControllers[self.rootVC.viewControllers.count - 3] as? BackupPrivateKeyViewController {
            lastVC.coordinator?.state.callback.hadSaveCallback.value?()
        }
    }
}

extension VerifyPriKeyCoordinator: VerifyPriKeyStateManagerProtocol {
    func switchPageState(_ state: PageState) {
        DispatchQueue.main.async {
            self.store.dispatch(PageStateAction(state: state))
        }
    }
}
