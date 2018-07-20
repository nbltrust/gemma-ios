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
    func pushPayment()
    func pushWallet()

}

protocol HomeStateManagerProtocol {
    var state: HomeState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<HomeState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState
    
    func getAccountInfo(_ account:String)
    
    func createDataInfo() -> [LineView.LineViewModel]
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
    func pushPayment() {
        if let vc = R.storyboard.payments.paymentsViewController() {
            let coordinator = PaymentsCoordinator(rootVC: self.rootVC)
            vc.coordinator = coordinator
            self.rootVC.pushViewController(vc, animated: true)
        }
    }

    func pushWallet() {
        if let vc = R.storyboard.wallet.walletViewController() {
            let coordinator = WalletCoordinator(rootVC: self.rootVC)
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
    
    func createDataInfo() -> [LineView.LineViewModel] {
        return [LineView.LineViewModel.init(name: R.string.localizable.payments_history(),
                                            content: "",
                                            image_name: R.image.icArrow.name,
                                            name_style: LineViewStyleNames.normal_name,
                                            content_style: LineViewStyleNames.normal_content,
                                            isBadge: false,
                                            content_line_number: 1,
                                            isShowLineView: false),
                LineView.LineViewModel.init(name: R.string.localizable.resources_pledge(),
                                            content: R.string.localizable.resource_get(),
                                            image_name: R.image.icArrow.name,
                                            name_style: LineViewStyleNames.normal_name,
                                            content_style: LineViewStyleNames.normal_content,
                                            isBadge: false,
                                            content_line_number: 1,
                                            isShowLineView: false)
        ]
    }
}
