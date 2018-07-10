//
//  PaymentsCoordinator.swift
//  EOS
//
//  Created 朱宋宇 on 2018/7/10.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

protocol PaymentsCoordinatorProtocol {
    
    func pushPaymentsDetail()

    
}

protocol PaymentsStateManagerProtocol {
    var state: PaymentsState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<PaymentsState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState
    
    func getDataFromServer(_ completion: @escaping (Bool)->Void )
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
    func pushPaymentsDetail() {
        guard let tradeVC = self.rootVC.topViewController as? PaymentsDetailViewController else { return }
        
        let vc = R.storyboard.paymentsDetail.paymentsDetailViewController()!
//        vc.pair = tradeVC.pair
        let coordinator = PaymentsDetailCoordinator(rootVC: self.rootVC)
        vc.coordinator = coordinator
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
    
    func getDataFromServer(_ completion: @escaping (Bool)->Void ) {
        EOSIONetwork.request(target: .get_info, success: { (json) in
            self.store.dispatch(FetchPaymentsRecordsListAction(data: [json]))
            completion(true)
        }, error: { (num) in
            
        }) { (error) in
            
        }
    }
}
