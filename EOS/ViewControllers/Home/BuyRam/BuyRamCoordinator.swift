//
//  BuyRamCoordinator.swift
//  EOS
//
//  Created zhusongyu on 2018/8/9.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift
import Presentr
import NBLCommonModule

protocol BuyRamCoordinatorProtocol {
    func presentMortgageConfirmVC(data: ConfirmViewModel)
    func pushToPaymentVC()
}

protocol BuyRamStateManagerProtocol {
    var state: BuyRamState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<BuyRamState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState
    
    func exchangeCalculate(_ amount: String, type: ExchangeType)
    func getAccountInfo(_ account:String)
    func buyRamValid(_ buyRam: String, blance: String)
    func sellRamValid(_ sellRam: String, blance: String)
}

class BuyRamCoordinator: HomeRootCoordinator {
    
    lazy var creator = BuyRamPropertyActionCreate()
    
    var store = Store<BuyRamState>(
        reducer: BuyRamReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
    
    override func register() {
        Broadcaster.register(BuyRamCoordinatorProtocol.self, observer: self)
        Broadcaster.register(BuyRamStateManagerProtocol.self, observer: self)
    }
}

extension BuyRamCoordinator: BuyRamCoordinatorProtocol {
    func presentMortgageConfirmVC(data: ConfirmViewModel) {
        let width = ModalSize.full
        let height = ModalSize.custom(size: 260)
        let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: 0, y: UIScreen.main.bounds.height - 260))
        let customType = PresentationType.custom(width: width, height: height, center: center)
        
        let presenter = Presentr(presentationType: customType)
        presenter.dismissOnTap = false
        presenter.keyboardTranslationType = .stickToTop
        
        let newVC = BaseNavigationController()
        newVC.navStyle = .white
        let transferConfirm = TransferConfirmRootCoordinator(rootVC: newVC)
        
        if let vc = R.storyboard.transfer.transferConfirmViewController() {
            let coordinator = TransferConfirmCoordinator(rootVC: transferConfirm.rootVC)
            vc.coordinator = coordinator
            vc.data = data
            transferConfirm.rootVC.pushViewController(vc, animated: true)
        }
        self.rootVC.topViewController?.customPresentViewController(presenter, viewController: newVC, animated: true, completion: nil)
    }
    
    func pushToPaymentVC() {
        if let vc = R.storyboard.payments.paymentsViewController() {
            let coordinator = PaymentsCoordinator(rootVC: self.rootVC)
            vc.coordinator = coordinator
            self.rootVC.pushViewController(vc, animated: true)
        }
    }
}

extension BuyRamCoordinator: BuyRamStateManagerProtocol {
    func exchangeCalculate(_ amount: String, type: ExchangeType) {
        self.store.dispatch(ExchangeAction(amount: amount, type: type))
    }
    
    func buyRamValid(_ buyRam: String, blance: String) {
        self.store.dispatch(BuyRamAction(ram: buyRam, balance: blance))
    }
    
    func sellRamValid(_ sellRam: String, blance: String) {
        self.store.dispatch(SellRamAction(ram: sellRam, balance: blance))
    }
    
    var state: BuyRamState {
        return store.state
    }
    
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<BuyRamState>) -> Subscription<SelectedState>)?
        ) where S.StoreSubscriberStateType == SelectedState {
        store.subscribe(subscriber, transform: transform)
    }
    
    func getAccountInfo(_ account:String) {
        EOSIONetwork.request(target: .get_currency_balance(account: account), success: { (json) in
            self.store.dispatch(BBalanceFetchedAction(balance: json))
        }, error: { (code) in
            
        }) { (error) in
            
        }
        
        EOSIONetwork.request(target: .get_account(account: account, otherNode: false), success: { (json) in
            if let accountObj = Account.deserialize(from: json.dictionaryObject) {
                self.store.dispatch(BAccountFetchedAction(info: accountObj))
            }
            
        }, error: { (code) in
            
        }) { (error) in
            
        }
        
        getRamPrice { (price) in
            if let price = price as? Decimal {
                self.store.dispatch(RamPriceAction(price: price))
            }
        }
    }
}
