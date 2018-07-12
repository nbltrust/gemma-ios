//
//  HomeCoordinator.swift
//  EOS
//
//  Created koofrank on 2018/7/4.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

protocol HomeCoordinatorProtocol {
    func pushPaymentDetail()
}

protocol HomeStateManagerProtocol {
    var state: HomeState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<HomeState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState
    
    func getAccountInfo(_ account:String)
}

class HomeCoordinator: HomeRootCoordinator {
    
    lazy var creator = HomePropertyActionCreate()
    
    var store = Store<HomeState>(
        reducer: HomeReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
}

extension HomeCoordinator: HomeCoordinatorProtocol {
    func pushPaymentDetail() {
        if let vc = R.storyboard.paymentsDetail.paymentsDetailViewController() {
            let coordinator = PaymentsDetailCoordinator(rootVC: self.rootVC)
            vc.coordinator = coordinator
            self.rootVC.pushViewController(vc, animated: true)
        }
    }
}

extension HomeCoordinator: HomeStateManagerProtocol {
    var state: HomeState {
        return store.state
    }
    
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<HomeState>) -> Subscription<SelectedState>)?
        ) where S.StoreSubscriberStateType == SelectedState {
        store.subscribe(subscriber, transform: transform)
    }
    
    func getAccountInfo(_ account:String) {
        EOSIONetwork.request(target: .get_currency_balance(account: account), success: { (json) in
            self.store.dispatch(BalanceFetchedAction(balance: json))
        }, error: { (code) in
            
        }) { (error) in
            
        }
        
        EOSIONetwork.request(target: .get_account(account: account), success: { (json) in
            if let accountObj = Account.deserialize(from: json.dictionaryObject) {
                self.store.dispatch(AccountFetchedAction(info: accountObj))
            }

        }, error: { (code) in
            
        }) { (error) in
            
        }
        
        SimpleHTTPService.requestETHPrice().done { (json) in
            if let eos = json.filter({ $0["name"].stringValue == NetworkConfiguration.EOSIO_DEFAULT_SYMBOL }).first {
                self.store.dispatch(RMBPriceFetchedAction(price: eos))
            }
            
        }.cauterize()
    }
}
