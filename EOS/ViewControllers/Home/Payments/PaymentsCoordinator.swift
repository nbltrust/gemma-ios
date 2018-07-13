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
    
    func pushPaymentsDetail(data:PaymentsRecordsViewModel)

    
}

protocol PaymentsStateManagerProtocol {
    var state: PaymentsState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<PaymentsState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState
    
    func getDataFromServer(_ account: String, completion: @escaping (Bool)->Void,isRefresh:Bool)
}

class PaymentsCoordinator: HomeRootCoordinator {
    
    lazy var creator = PaymentsPropertyActionCreate()
    
    var store = Store<PaymentsState>(
        reducer: PaymentsReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
}

extension PaymentsCoordinator: PaymentsCoordinatorProtocol {
    func pushPaymentsDetail(data:PaymentsRecordsViewModel) {
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
    
    func getDataFromServer(_ account: String, completion: @escaping (Bool)->Void, isRefresh:Bool) {
        NBLNetwork.request(target: NBLService.accountHistory(account: account, showNum: 10, lastPosition: isRefresh ? -1 :state.property.last_pos), success: { (data) in
            let dataDic = data["result"].dictionaryValue
            let transactions = dataDic["transactions"]?.arrayValue
            
            self.store.dispatch(GetLastPosAction(last_pos:(dataDic["last_pos"]?.intValue)!))
        
            let payments = transactions?.map({ (json) in
                Payment.deserialize(from: json.dictionaryObject)
            })

            self.store.dispatch(FetchPaymentsRecordsListAction(data: payments! as! [Payment]))
            completion(true)
        }, error: { (code) in
           
            if let gemmaerror = GemmaError.NBLNetworkErrorCode(rawValue: code) {
                let error = GemmaError.NBLCode(code: gemmaerror)
                KRProgressHUD.showError(withMessage: error.localizedDescription)
            } else {
                KRProgressHUD.showError(withMessage: R.string.localizable.error_unknow())
            }
            completion(false)

        }) { (moyaError) in
            let payment:[Payment] = []
            self.store.dispatch(FetchPaymentsRecordsListAction(data: payment))
            completion(false)

            KRProgressHUD.showError(withMessage: R.string.localizable.request_failed())
        }
    }
}
