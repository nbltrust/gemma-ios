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
}

protocol TransferConfirmCoordinatorProtocol {
    func pushToTransferConfirmPwdVC(toAccount: String, money: String, remark: String, type: String)

    func pushToTransferFPConfirmVC(toAccount: String, money: String, remark: String, type: String)

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
        reducer: TransferConfirmReducer,
        state: nil,
        middleware: [TrackingMiddleware]
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
    func pushToTransferConfirmPwdVC(toAccount: String, money: String, remark: String, type: String) {
        var context = TransferConfirmPasswordContext()
        context.receiver = toAccount
        context.amount = money
        context.remark = remark
        context.type = type
        context.iconType = leftIconType.pop.rawValue

        pushVC(TransferConfirmPasswordCoordinator.self, animated: true, context: context)
    }

    func pushToTransferFPConfirmVC(toAccount: String, money: String, remark: String, type: String) {
        var context = BLTCardConfirmFingerPrinterContext()
        context.receiver = toAccount
        context.amount = money
        context.remark = remark
        context.type = type
        context.iconType = leftIconType.pop.rawValue

        pushVC(BLTCardConfirmFingerPrinterCoordinator.self, animated: true, context: context)
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
