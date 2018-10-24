//
//  BLTCardConnectCoordinator.swift
//  EOS
//
//  Created peng zhu on 2018/10/4.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift
import NBLCommonModule

protocol BLTCardConnectCoordinatorProtocol {
    func dismissVC(_ complication: @escaping () -> Void)
}

protocol BLTCardConnectStateManagerProtocol {
    var state: BLTCardConnectState { get }

    func switchPageState(_ state: PageState)

    func reconnectDevice(_ success: @escaping SuccessedComplication, failed: @escaping FailedComplication)
}

class BLTCardConnectCoordinator: NavCoordinator {
    var store = Store(
        reducer: BLTCardConnectReducer,
        state: nil,
        middleware: [TrackingMiddleware]
    )

    var state: BLTCardConnectState {
        return store.state
    }

    override class func start(_ root: BaseNavigationController, context: RouteContext? = nil) -> BaseViewController {
        let vc = R.storyboard.bltCard.bltCardConnectViewController()!
        let coordinator = BLTCardConnectCoordinator(rootVC: root)
        vc.coordinator = coordinator
        coordinator.store.dispatch(RouteContextAction(context: context))
        return vc
    }

    override func register() {
        Broadcaster.register(BLTCardConnectCoordinatorProtocol.self, observer: self)
        Broadcaster.register(BLTCardConnectStateManagerProtocol.self, observer: self)
    }
}

extension BLTCardConnectCoordinator: BLTCardConnectCoordinatorProtocol {
    func dismissVC(_ complication: @escaping () -> Void) {
        self.rootVC.dismiss(animated: true, completion: complication)
    }
}

extension BLTCardConnectCoordinator: BLTCardConnectStateManagerProtocol {
    func switchPageState(_ state: PageState) {
        DispatchQueue.main.async {
            self.store.dispatch(PageStateAction(state: state))
        }
    }

    func reconnectDevice(_ success: @escaping SuccessedComplication, failed: @escaping FailedComplication) {
        var deviceName = ""
        if let wallet = WalletManager.shared.currentWallet() {
            deviceName = wallet.deviceName ?? ""
        }
        BLTWalletIO.shareInstance()?.searchBLTCard({
            BLTWalletIO.shareInstance()?.connectCard(deviceName, success: success, failed: failed)
        })
    }
}
