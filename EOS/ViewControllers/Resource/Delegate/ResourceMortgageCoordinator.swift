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
    func popVC()
    func pushToDetailVC(_ model: AssetViewModel)
}

protocol ResourceMortgageStateManagerProtocol {
    var state: ResourceMortgageState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<ResourceMortgageState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState

    func cpuValidMoney(_ cpuMoney: String, netMoney: String, blance: String)
    func netValidMoney(_ cpuMoney: String, netMoney: String, blance: String)

    func cpuReliveValidMoney(_ cpuMoney: String, netMoney: String, blance: String)
    func netReliveValidMoney(_ cpuMoney: String, netMoney: String, blance: String)

    func fetchData(_ balance: String, cpuBalance: String, netBalance: String)
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
        let height = ModalSize.custom(size: 354)
        let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: 0, y: UIScreen.main.bounds.height - 354))
        let customType = PresentationType.custom(width: width, height: height, center: center)

        let presenter = Presentr(presentationType: customType)
//        presenter.dismissOnTap = false
        presenter.keyboardTranslationType = .stickToTop

        var context = TransferConfirmContext()
        context.data = data
        presentVC(TransferConfirmCoordinator.self, context: context, navSetup: { (nav) in
            nav.navStyle = .common
        }) { (top, target) in
            top.customPresentViewController(presenter, viewController: target, animated: true, completion: nil)
        }
    }
    func pushToDetailVC(_ model: AssetViewModel) {
        for viewController in self.rootVC.viewControllers {
            if let assetDetailVC = viewController as? AssetDetailViewController {
                self.rootVC.popToViewController(assetDetailVC, animated: true)
                return
            }
        }
        var context = AssetDetailContext()
        context.model = model
        self.pushVC(AssetDetailCoordinator.self, animated: true, context: context)
    }
    func popVC() {
        self.rootVC.popViewController()
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

    func fetchData(_ balance: String, cpuBalance: String, netBalance: String) {
        self.store.dispatch(FetchDataAction(balance: balance, cpuBalance: cpuBalance, netBalance: netBalance))
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
}
