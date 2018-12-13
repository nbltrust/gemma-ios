//
//  BLTCardConfirmFingerPrinterCoordinator.swift
//  EOS
//
//  Created peng zhu on 2018/9/13.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift
import NBLCommonModule

protocol BLTCardConfirmFingerPrinterCoordinatorProtocol {
    func finishTransfer()

    func dismissNav()

    func popVC()

    func pushToPinConfirmVC()
}

protocol BLTCardConfirmFingerPrinterStateManagerProtocol {
    var state: BLTCardConfirmFingerPrinterState { get }

    func switchPageState(_ state: PageState)

    func bltTransferAccounts(_ account: String, amount: String, remark: String, callback:@escaping (Bool, String) -> Void)

    func verifyFP(_ state: @escaping VerifyFingerComplication,
                  success: @escaping SuccessedComplication,
                  failed: @escaping FailedComplication,
                  timeout: @escaping TimeoutComplication)

    func createWookongBioWallet(_ success: @escaping SuccessedComplication,
                                failed: @escaping FailedComplication)

    func cancelEntroll()
}

class BLTCardConfirmFingerPrinterCoordinator: BLTCardRootCoordinator {
    var store = Store(
        reducer: BLTCardConfirmFingerPrinterReducer,
        state: nil,
        middleware: [trackingMiddleware]
    )

    var state: BLTCardConfirmFingerPrinterState {
        return store.state
    }

    override class func start(_ root: BaseNavigationController, context: RouteContext? = nil) -> BaseViewController {
        let currentVC = R.storyboard.bltCard.bltCardConfirmFingerPrinterViewController()!
        let coordinator = BLTCardConfirmFingerPrinterCoordinator(rootVC: root)
        currentVC.coordinator = coordinator
        coordinator.store.dispatch(RouteContextAction(context: context))
        return currentVC
    }
}

extension BLTCardConfirmFingerPrinterCoordinator: BLTCardConfirmFingerPrinterCoordinatorProtocol {
    func finishTransfer() {
        if let newHomeCoor = appCoodinator.newHomeCoordinator, let transferVC = newHomeCoor.rootVC.topViewController as? TransferViewController {
            self.rootVC.dismiss(animated: true) {
                transferVC.resetData()
            }
        }
    }

    func dismissNav() {
        cancelEntroll()
        self.rootVC.dismiss(animated: true, completion: nil)
    }

    func popVC() {
        cancelEntroll()
        self.rootVC.popViewController(animated: true)
    }

    func pushToPinConfirmVC() {
        
    }
}

extension BLTCardConfirmFingerPrinterCoordinator: BLTCardConfirmFingerPrinterStateManagerProtocol {
    func switchPageState(_ state: PageState) {
        self.store.dispatch(PageStateAction(state: state))
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
        model.confirmType = fpType
        model.contract = EOSIOContract.TokenCode
        model.symbol = "EOS"
        transaction(EOSAction.bltTransfer.rawValue, actionModel: model) {[weak self] (bool, showString) in
            callback(bool, showString)
        }
    }

    func verifyFP(_ state: @escaping VerifyFingerComplication, success: @escaping SuccessedComplication, failed: @escaping FailedComplication, timeout: @escaping TimeoutComplication) {
        BLTWalletIO.shareInstance()?.verifyFingerPrinter(state, success: success, failed: failed, timeout: timeout)
    }

    func createWookongBioWallet(_ success: @escaping SuccessedComplication, failed: @escaping FailedComplication) {
        importWookongBioWallet(self.rootVC, hint:"", success: success, failed: failed)
    }
    
    func cancelEntroll() {
        BLTWalletIO.shareInstance()?.cancelSignAbort()
    }
}
