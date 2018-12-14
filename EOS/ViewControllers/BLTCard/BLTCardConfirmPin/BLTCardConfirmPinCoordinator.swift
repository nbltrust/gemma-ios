//
//  BLTCardConfirmPinCoordinator.swift
//  EOS
//
//  Created peng zhu on 2018/9/13.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift
import NBLCommonModule

protocol BLTCardConfirmPinCoordinatorProtocol {
    func dismissVC(_ complication: @escaping () -> Void)

    func popVC()

    func finishTransfer()

    func pushToPowerAlertVC()
}

protocol BLTCardConfirmPinStateManagerProtocol {
    var state: BLTCardConfirmPinState { get }

    func switchPageState(_ state: PageState)

    func confirmPin(_ pin: String, complication: @escaping SuccessedComplication)

    func bltTransferAccounts(_ account: String, amount: String, remark: String, callback:@escaping (Bool, String) -> Void)
}

class BLTCardConfirmPinCoordinator: BLTCardRootCoordinator {
    var store = Store(
        reducer: BLTCardConfirmPinReducer,
        state: nil,
        middleware: [trackingMiddleware]
    )

    var state: BLTCardConfirmPinState {
        return store.state
    }

    override class func start(_ root: BaseNavigationController, context: RouteContext? = nil) -> BaseViewController {
        let currentVC = R.storyboard.bltCard.bltCardConfirmPinViewController()!
        let coordinator = BLTCardConfirmPinCoordinator(rootVC: root)
        currentVC.coordinator = coordinator
        coordinator.store.dispatch(RouteContextAction(context: context))
        return currentVC
    }

    override func register() {
        Broadcaster.register(BLTCardConfirmPinCoordinatorProtocol.self, observer: self)
        Broadcaster.register(BLTCardConfirmPinStateManagerProtocol.self, observer: self)
    }
}

extension BLTCardConfirmPinCoordinator: BLTCardConfirmPinCoordinatorProtocol {
    func dismissVC(_ complication: @escaping () -> Void) {
        self.rootVC.dismiss(animated: true, completion: complication)
    }

    func popVC() {
        self.rootVC.popViewController(animated: true, nil)
    }

    func finishTransfer() {
        if let newHomeCoor = appCoodinator.newHomeCoordinator,
            let transferVC = newHomeCoor.rootVC.topViewController as? TransferViewController {
            self.rootVC.dismiss(animated: true) {
                transferVC.resetData()
            }
        }
    }

    func pushToPowerAlertVC() {
        var context = BLTCardPowerOnContext()
        context.needAttention = true
        context.actionRetry = { [weak self] () in
            guard let `self` = self else {return}
            let vcs = self.rootVC.viewControllers
            if let currentVC = vcs[vcs.count - 2] as? BLTCardConfirmPinViewController {
                currentVC.startTransfer()
            }
        }

        pushVC(BLTCardPowerOnCoordinator.self, animated: true, context: context)
    }
}

extension BLTCardConfirmPinCoordinator: BLTCardConfirmPinStateManagerProtocol {
    func switchPageState(_ state: PageState) {
        self.store.dispatch(PageStateAction(state: state))
    }
    
    func confirmPin(_ pin: String, complication: @escaping SuccessedComplication) {
        BLTWalletIO.shareInstance()?.verifyPin(pin, success: complication, failed: { (reason) in
            if let failedReason = reason {
                showFailTop(failedReason)
            }
        })
    }

    func bltTransferAccounts(_ account: String, amount: String, remark: String, callback:@escaping (Bool, String) -> Void) {
        let model = TransferActionModel()
        model.toAccount = account
        model.fromAccount = CurrencyManager.shared.getCurrentAccountName()
        model.success = R.string.localizable.transfer_successed.key.localized()
        model.faile = R.string.localizable.transfer_failed.key.localized()
        model.amount = amount
        model.remark = remark
        model.type = .bluetooth
        model.confirmType = pinType
        model.contract = EOSIOContract.TokenCode
        model.symbol = "EOS"
        transaction(EOSAction.bltTransfer.rawValue, actionModel: model) { (bool, showString) in
            callback(bool, showString)
        }
    }
}
