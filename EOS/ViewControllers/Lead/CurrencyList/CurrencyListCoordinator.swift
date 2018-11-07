//
//  CurrencyListCoordinator.swift
//  EOS
//
//  Created peng zhu on 2018/10/30.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift
import NBLCommonModule

protocol CurrencyListCoordinatorProtocol {
    func popVC()
}

protocol CurrencyListStateManagerProtocol {
    var state: CurrencyListState { get }

    func switchPageState(_ state:PageState)
}

class CurrencyListCoordinator: NavCoordinator {
    var store = Store(
        reducer: gCurrencyListReducer,
        state: nil,
        middleware:[trackingMiddleware]
    )
    
    var state: CurrencyListState {
        return store.state
    }
    
    override class func start(_ root: BaseNavigationController, context:RouteContext? = nil) -> BaseViewController {
        let vc = R.storyboard.leadIn.currencyListViewController()!
        let coordinator = CurrencyListCoordinator(rootVC: root)
        vc.coordinator = coordinator
        coordinator.store.dispatch(RouteContextAction(context: context))
        return vc
    }

    override func register() {
        Broadcaster.register(CurrencyListCoordinatorProtocol.self, observer: self)
        Broadcaster.register(CurrencyListStateManagerProtocol.self, observer: self)
    }
}

extension CurrencyListCoordinator: CurrencyListCoordinatorProtocol {
    func popVC() {
        self.rootVC.popViewController(animated: true)
    }
}

extension CurrencyListCoordinator: CurrencyListStateManagerProtocol {
    func switchPageState(_ state:PageState) {
        DispatchQueue.main.async {
            self.store.dispatch(PageStateAction(state: state))
        }
    }
}
