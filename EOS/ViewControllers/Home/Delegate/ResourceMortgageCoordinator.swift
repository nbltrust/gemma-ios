//
//  ResourceMortgageCoordinator.swift
//  EOS
//
//  Created zhusongyu on 2018/7/24.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift
import Presentr

protocol ResourceMortgageCoordinatorProtocol {
    func presentMortgageConfirmVC(data: ConfirmViewModel)
    func pushToPaymentVC()
}

protocol ResourceMortgageStateManagerProtocol {
    var state: ResourceMortgageState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<ResourceMortgageState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState

    func getAccountInfo(_ account: String)
    func cpuValidMoney(_ cpuMoney: String, netMoney: String, blance: String)
    func netValidMoney(_ cpuMoney: String, netMoney: String, blance: String)

    func cpuReliveValidMoney(_ cpuMoney: String, netMoney: String, blance: String)
    func netReliveValidMoney(_ cpuMoney: String, netMoney: String, blance: String)
    func getCurrentFromLocal()
}

class ResourceMortgageCoordinator: NavCoordinator {

    lazy var creator = ResourceMortgagePropertyActionCreate()

    var store = Store<ResourceMortgageState>(
        reducer: gResourceMortgageReducer,
        state: nil,
        middleware: [trackingMiddleware]
    )
}

extension ResourceMortgageCoordinator: ResourceMortgageCoordinatorProtocol {
    func presentMortgageConfirmVC(data: ConfirmViewModel) {
        let width = ModalSize.full
        let height = ModalSize.custom(size: 323)
        let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: 0, y: UIScreen.main.bounds.height - 323))
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

    func pushToPaymentVC() {
        let vc = R.storyboard.payments.paymentsViewController()!
        let coor = PaymentsCoordinator(rootVC: self.rootVC)
        vc.coordinator = coor
        self.rootVC.pushViewController(vc, animated: true)
    }
}

extension ResourceMortgageCoordinator: ResourceMortgageStateManagerProtocol {
    var state: ResourceMortgageState {
        return store.state
    }

    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<ResourceMortgageState>) -> Subscription<SelectedState>)?
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
    }

    func cpuValidMoney(_ cpuMoney: String, netMoney: String, blance: String) {
        self.store.dispatch(CpuMoneyAction(cpuMoney: cpuMoney, netMoney: netMoney, balance: blance))
    }

    func netValidMoney(_ cpuMoney: String, netMoney: String, blance: String) {
        self.store.dispatch(NetMoneyAction(cpuMoney: cpuMoney, netMoney: netMoney, balance: blance))
    }

    func cpuReliveValidMoney(_ cpuMoney: String, netMoney: String, blance: String) {
        self.store.dispatch(CpuReliveMoneyAction(cpuMoney: cpuMoney, netMoney: netMoney, balance: blance))
    }

    func netReliveValidMoney(_ cpuMoney: String, netMoney: String, blance: String) {
        self.store.dispatch(NetReliveMoneyAction(cpuMoney: cpuMoney, netMoney: netMoney, balance: blance))
    }

    func getCurrentFromLocal() {
        
    }
}
