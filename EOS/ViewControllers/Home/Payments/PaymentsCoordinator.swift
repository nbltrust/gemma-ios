//
//  PaymentsCoordinator.swift
//  EOS
//
//  Created 朱宋宇 on 2018/7/10.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift
import KRProgressHUD

protocol PaymentsCoordinatorProtocol {

    func pushPaymentsDetail(data: PaymentsRecordsViewModel)

}

protocol PaymentsStateManagerProtocol {
    var state: PaymentsState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<PaymentsState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState

    func getDataFromServer(_ account: String, completion: @escaping (Bool) -> Void, isRefresh: Bool)
}

class PaymentsCoordinator: NavCoordinator {

    lazy var creator = PaymentsPropertyActionCreate()

    var store = Store<PaymentsState>(
        reducer: gPaymentsReducer,
        state: nil,
        middleware: [trackingMiddleware]
    )
}

extension PaymentsCoordinator: PaymentsCoordinatorProtocol {
    func pushPaymentsDetail(data: PaymentsRecordsViewModel) {
        let vc = R.storyboard.paymentsDetail.paymentsDetailViewController()!
        let coordinator = PaymentsDetailCoordinator(rootVC: self.rootVC)
        vc.coordinator = coordinator
        vc.data = data
        self.rootVC.pushViewController(vc, animated: true)
    }
}

extension PaymentsCoordinator: PaymentsStateManagerProtocol {
    var state: PaymentsState {
        return store.state
    }

    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<PaymentsState>) -> Subscription<SelectedState>)?
        ) where S.StoreSubscriberStateType == SelectedState {
        store.subscribe(subscriber, transform: transform)
    }

    func getDataFromServer(_ account: String, completion: @escaping (Bool) -> Void, isRefresh: Bool) {
        NBLNetwork.request(target: NBLService.accountHistory(account: account, showNum: 10, lastPosition: isRefresh ? -1 :state.property.lastPos), success: { (data) in
            let transactions = data["transactions"].arrayValue

            if let lastPos = data["last_pos"].int {
                self.store.dispatch(GetLastPosAction(lastPos: lastPos))

                if let payments = transactions.map({ (json) in
                    Payment.deserialize(from: json.dictionaryObject)
                }) as? [Payment] {
                    self.store.dispatch(FetchPaymentsRecordsListAction(data: payments))
                }
            }

            completion(true)
        }, error: { (code) in

            if let gemmaerror = GemmaError.NBLNetworkErrorCode(rawValue: code) {
                let error = GemmaError.NBLCode(code: gemmaerror)
                showFailTop(error.localizedDescription)
            } else {
                showFailTop(R.string.localizable.error_unknow.key.localized())
            }
            completion(false)

        }) { (_) in
            let payment: [Payment] = []
            self.store.dispatch(FetchPaymentsRecordsListAction(data: payment))
            completion(false)
        }
    }
}
