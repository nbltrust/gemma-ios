//
//  DeleteFingerCoordinator.swift
//  EOS
//
//  Created zhusongyu on 2018/10/12.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift
import NBLCommonModule

protocol DeleteFingerCoordinatorProtocol {
    func pushToChangeWalletName(model: WalletManagerModel, index: Int)
}

protocol DeleteFingerStateManagerProtocol {
    var state: DeleteFingerState { get }

    func switchPageState(_ state: PageState)

    func deleteCurrentFinger(_ model: WalletManagerModel, index: Int)
}

class DeleteFingerCoordinator: NavCoordinator {
    var store = Store(
        reducer: gDeleteFingerReducer,
        state: nil,
        middleware: [trackingMiddleware]
    )

    var state: DeleteFingerState {
        return store.state
    }

    override class func start(_ root: BaseNavigationController, context: RouteContext? = nil) -> BaseViewController {
        let vc = R.storyboard.wallet.deleteFingerViewController()!
        let coordinator = DeleteFingerCoordinator(rootVC: root)
        vc.coordinator = coordinator
        coordinator.store.dispatch(RouteContextAction(context: context))
        return vc
    }

    override func register() {
        Broadcaster.register(DeleteFingerCoordinatorProtocol.self, observer: self)
        Broadcaster.register(DeleteFingerStateManagerProtocol.self, observer: self)
    }
}

extension DeleteFingerCoordinator: DeleteFingerCoordinatorProtocol {
    func pushToChangeWalletName(model: WalletManagerModel, index: Int) {
        if let vc = R.storyboard.wallet.changeWalletNameViewController() {
            let coordinator = ChangeWalletNameCoordinator(rootVC: self.rootVC)
            vc.coordinator = coordinator
            vc.model = model
            vc.fingerIndex = index
            vc.type = .fingerName
            self.rootVC.pushViewController(vc, animated: true)
        }
    }
}

extension DeleteFingerCoordinator: DeleteFingerStateManagerProtocol {
    func switchPageState(_ state: PageState) {
        DispatchQueue.main.async {
            self.store.dispatch(PageStateAction(state: state))
        }
    }

    func deleteCurrentFinger(_ model: WalletManagerModel, index: Int) {
        BLTWalletIO.shareInstance()?.deleteFP([String(format: "%d", index)], success: { [weak self] in
            guard let `self` = self else { return }
            FingerManager.shared.deleteFingerName(model, index: index)
            self.rootVC.popViewController(animated: true)
        }, failed: { (reason) in
            if let failedReason = reason {
                showFailTop(failedReason)
            }
        })
    }
}
