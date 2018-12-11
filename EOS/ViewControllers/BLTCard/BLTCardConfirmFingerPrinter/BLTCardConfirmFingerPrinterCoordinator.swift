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
        BLTWalletIO.shareInstance()?.cancelEntrollFingerPrinter({
            self.rootVC.dismiss(animated: true, completion: nil)
        }, failed: { (reason) in
            if let failedReason = reason {
                showFailTop(failedReason)
            }
        })
    }

    func popVC() {
        BLTWalletIO.shareInstance()?.cancelEntrollFingerPrinter({
            self.rootVC.popViewController(animated: true)
        }, failed: { (reason) in
            if let failedReason = reason {
                showFailTop(failedReason)
            }
        })
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
        transaction(EOSAction.bltTransfer.rawValue, actionModel: model) { (bool, showString) in
            //            if bool == false, showString == "" {
            BLTWalletIO.shareInstance()?.getVolidation({ [weak self] (sn, snSig, pub, pubSig, publicKey) in
                guard let `self` = self else { return }
                var validation = WookongValidation()
                validation.SN = sn ?? ""
                validation.SNSig = snSig ?? ""
                validation.pubKey = pub ?? ""
                validation.publicKeySig = pubSig ?? ""
                validation.publicKey = publicKey ?? ""
                NBLNetwork.request(target: .getGoodscode(code: validation.SN), success: { (success) in

                }, error: { (error) in

                }, failure: { (fail) in

                })
                }, failed: { (reason) in
                    callback(false, R.string.localizable.eos_chain_instability.key.localized())
            })
            //            } else {
            //                callback(bool, showString)
            //            }
        }
    }

    func verifyFP(_ state: @escaping VerifyFingerComplication, success: @escaping SuccessedComplication, failed: @escaping FailedComplication, timeout: @escaping TimeoutComplication) {
        BLTWalletIO.shareInstance()?.verifyFingerPrinter(state, success: success, failed: failed, timeout: timeout)
    }

    func createWookongBioWallet(_ success: @escaping SuccessedComplication, failed: @escaping FailedComplication) {
        importWookongBioWallet(self.rootVC, hint:"", success: success, failed: failed)
    }
}
