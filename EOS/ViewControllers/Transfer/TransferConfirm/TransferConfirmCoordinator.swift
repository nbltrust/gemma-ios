//
//  TransferConfirmCoordinator.swift
//  EOS
//
//  Created 朱宋宇 on 2018/7/12.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift
import HandyJSON

struct TransferConfirmContext: RouteContext, HandyJSON {
    var data: ConfirmViewModel = ConfirmViewModel()
    var type: CreateAPPId = .gemma
    var model: AssetViewModel = AssetViewModel()
}

protocol TransferConfirmCoordinatorProtocol {
    func pushToTransferConfirmPwdVC(toAccount: String, money: String, remark: String, type: String, model: AssetViewModel)

    func pushToWookongBioTransferConfirmVC(toAccount: String, money: String, remark: String, type: String)

    func dismissConfirmVC()
}

protocol TransferConfirmStateManagerProtocol {
    var state: TransferConfirmState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<TransferConfirmState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState
}

class TransferConfirmCoordinator: NavCoordinator {

    lazy var creator = TransferConfirmPropertyActionCreate()

    var store = Store<TransferConfirmState>(
        reducer: gTransferConfirmReducer,
        state: nil,
        middleware: [trackingMiddleware]
    )

    override class func start(_ root: BaseNavigationController, context: RouteContext? = nil) -> BaseViewController {
        let vc = R.storyboard.transfer.transferConfirmViewController()!
        let coordinator = TransferConfirmCoordinator(rootVC: root)
        vc.coordinator = coordinator
        coordinator.store.dispatch(RouteContextAction(context: context))
        return vc
    }
}

extension TransferConfirmCoordinator: TransferConfirmCoordinatorProtocol {
    func pushToTransferConfirmPwdVC(toAccount: String, money: String, remark: String, type: String, model: AssetViewModel) {
        var context = TransferConfirmPasswordContext()
        context.currencyID = CurrencyManager.shared.getCurrentCurrencyID()
        context.receiver = toAccount
        context.amount = money
        context.remark = remark
        context.type = type
        context.iconType = LeftIconType.pop.rawValue
        context.model = model
        let frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 244, width: UIScreen.main.bounds.width, height: 244)
//        self.rootVC.topViewController?.presentationController!.presentedView!.frame = frame
//        self.rootVC.topViewController
        self.rootVC.topViewController?.navigationController?.view.frame = frame
        pushVC(TransferConfirmPasswordCoordinator.self, animated: true, context: context)
    }

    func pushToWookongBioTransferConfirmVC(toAccount: String, money: String, remark: String, type: String) {
        BLTWalletIO.shareInstance()?.getFPList({ [weak self] (fpList) in
            guard let `self` = self else {return}
            if let list = fpList, list.count > 0 {
                var context = BLTCardConfirmFingerPrinterContext()
                context.receiver = toAccount
                context.amount = money
                context.remark = remark
                context.type = type
                context.iconType = LeftIconType.pop.rawValue

                self.pushVC(BLTCardConfirmFingerPrinterCoordinator.self, animated: true, context: context)
            } else {
                var context = BLTCardConfirmPinContext()
                context.receiver = toAccount
                context.amount = money
                context.remark = remark
                context.type = type
                context.iconType = LeftIconType.pop.rawValue
                context.confirmType = .transferWithPin

                self.pushVC(BLTCardConfirmPinCoordinator.self, animated: true, context: context)
            }
        }, failed: { (failedReason) in
            if let reason = failedReason {
                showFailTop(reason)
            }
        })
    }

    func dismissConfirmVC() {
        self.rootVC.dismiss(animated: true, completion: nil)
    }

}

extension TransferConfirmCoordinator: TransferConfirmStateManagerProtocol {
    var state: TransferConfirmState {
        return store.state
    }

    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<TransferConfirmState>) -> Subscription<SelectedState>)?
        ) where S.StoreSubscriberStateType == SelectedState {
        store.subscribe(subscriber, transform: transform)
    }

}
