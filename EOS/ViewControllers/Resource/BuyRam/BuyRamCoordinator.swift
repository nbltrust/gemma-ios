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
    func popVC()
    func pushToDetailVC(_ model: AssetViewModel)
}

protocol BuyRamStateManagerProtocol {
    var state: BuyRamState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<BuyRamState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState

    func exchangeCalculate(_ amount: String, type: ExchangeType)
    func getAccountInfo(_ account: String)
    func buyRamValid(_ buyRam: String, blance: String)
    func sellRamValid(_ sellRam: String, blance: String)
}

class BuyRamCoordinator: NavCoordinator {

    lazy var creator = BuyRamPropertyActionCreate()

    var store = Store<BuyRamState>(
        reducer: gBuyRamReducer,
        state: nil,
        middleware: [trackingMiddleware]
    )

    override class func start(_ root: BaseNavigationController, context: RouteContext? = nil) -> BaseViewController {
        let vc = R.storyboard.buyRam.buyRamViewController()!
        let coordinator = BuyRamCoordinator(rootVC: root)
        vc.coordinator = coordinator
        coordinator.store.dispatch(RouteContextAction(context: context))

        return vc
    }

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

        var context = TransferConfirmContext()
        context.data = data
        presentVC(TransferConfirmCoordinator.self, context: context, navSetup: { (nav) in
            nav.navStyle = .common
        }) { (top, target) in
            top.customPresentViewController(presenter, viewController: target, animated: true, completion: nil)
        }
    }

    func popVC() {
        self.rootVC.popViewController()
    }
    func pushToDetailVC(_ model: AssetViewModel) {
        var context = AssetDetailContext()
        context.model = model
        self.pushVC(AssetDetailCoordinator.self, animated: true, context: context)
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

    func getAccountInfo(_ account: String) {
        if let json = CurrencyManager.shared.getAccountJsonWith(account), let accountObj = Account.deserialize(from: json.dictionaryObject) {
            self.store.dispatch(MAccountFetchedAction(info: accountObj))
        }
        if let json = CurrencyManager.shared.getBalanceJsonWith(account) {
            self.store.dispatch(MBalanceFetchedAction(balance: json))

        }
        
        EOSIONetwork.request(target: .getCurrencyBalance(account: account), success: { (json) in
            self.store.dispatch(MBalanceFetchedAction(balance: json))
        }, error: { (_) in

        }) { (_) in

        }

        EOSIONetwork.request(target: .getAccount(account: account, otherNode: false), success: { (json) in
            if let accountObj = Account.deserialize(from: json.dictionaryObject) {
                self.store.dispatch(MAccountFetchedAction(info: accountObj))
            }

        }, error: { (_) in

        }) { (_) in

        }

        getRamPrice { (price) in
            if let price = price as? Decimal {
                self.store.dispatch(RamPriceAction(price: price))
            }
        }
    }
}
