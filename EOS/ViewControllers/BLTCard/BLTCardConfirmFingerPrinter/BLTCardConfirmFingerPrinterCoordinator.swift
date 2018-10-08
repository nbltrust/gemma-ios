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
}

protocol BLTCardConfirmFingerPrinterStateManagerProtocol {
    var state: BLTCardConfirmFingerPrinterState { get }
    
    func switchPageState(_ state:PageState)
    
    func bltTransferAccounts(_ account:String, amount:String, remark:String ,callback:@escaping (Bool, String)->())
}

class BLTCardConfirmFingerPrinterCoordinator: BLTCardRootCoordinator {
    var store = Store(
        reducer: BLTCardConfirmFingerPrinterReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
    
    var state: BLTCardConfirmFingerPrinterState {
        return store.state
    }
            
    override class func start(_ root: BaseNavigationController, context: RouteContext? = nil) -> BaseViewController {
        let vc = R.storyboard.bltCard.bltCardConfirmFingerPrinterViewController()!
        let coordinator = BLTCardConfirmFingerPrinterCoordinator(rootVC: root)
        vc.coordinator = coordinator
        coordinator.store.dispatch(RouteContextAction(context: context))
        return vc
    }
}

extension BLTCardConfirmFingerPrinterCoordinator: BLTCardConfirmFingerPrinterCoordinatorProtocol {
    func finishTransfer() {
        if let transferCoor = app_coodinator.transferCoordinator, let transferVC = transferCoor.rootVC.topViewController as? TransferViewController {
            self.rootVC.dismiss(animated: true) {
                transferVC.resetData()
            }
        }
    }
}

extension BLTCardConfirmFingerPrinterCoordinator: BLTCardConfirmFingerPrinterStateManagerProtocol {
    func switchPageState(_ state:PageState) {
        self.store.dispatch(PageStateAction(state: state))
    }
    
    func bltTransferAccounts(_ account:String, amount:String, remark:String ,callback:@escaping (Bool, String)->()) {
        BLTWalletIO.shareInstance()?.submmitWaitingVerfyPin("123456")
        BLTWalletIO.shareInstance()?.getEOSSign(.init(2), success: { (sign) in
            let model = TransferActionModel()
            model.toAccount = account
            model.fromAccount = WalletManager.shared.getAccount()
            model.success = R.string.localizable.transfer_successed.key.localized()
            model.faile = R.string.localizable.transfer_failed.key.localized()
            model.amount = amount
            model.remark = remark
            model.type = .bluetooth
            model.sign = sign ?? ""
            transaction(EOSAction.bltTransfer.rawValue, actionModel: model) { (bool, showString) in
                callback(bool,showString)
            }
        }, failed: { (reason) in
            if let failedReason = reason {
                showFailTop(failedReason)
            }
        })
    }
}
