//
//  AccountListCoordinator.swift
//  EOS
//
//  Created peng zhu on 2018/11/7.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift
import NBLCommonModule

protocol AccountListCoordinatorProtocol {
    func dismissListVC()
}

protocol AccountListStateManagerProtocol {
    var state: AccountListState { get }
    
    func switchPageState(_ state: PageState)

    func selectAtIndex(_ index: Int)
}

class AccountListCoordinator: NavCoordinator {
    var store = Store(
        reducer: gAccountListReducer,
        state: nil,
        middleware: [trackingMiddleware]
    )
    
    var state: AccountListState {
        return store.state
    }
    
    override class func start(_ root: BaseNavigationController, context: RouteContext? = nil) -> BaseViewController {
        let vc = R.storyboard.accountList.accountListViewController()!
        let coordinator = AccountListCoordinator(rootVC: root)
        vc.coordinator = coordinator
        coordinator.store.dispatch(RouteContextAction(context: context))
        return vc
    }

    override func register() {
        Broadcaster.register(AccountListCoordinatorProtocol.self, observer: self)
        Broadcaster.register(AccountListStateManagerProtocol.self, observer: self)
    }
}

extension AccountListCoordinator: AccountListCoordinatorProtocol {
    func dismissListVC() {
        self.rootVC.dismiss(animated: true, completion: nil)
    }
}

extension AccountListCoordinator: AccountListStateManagerProtocol {
    func switchPageState(_ state: PageState) {
        DispatchQueue.main.async {
            self.store.dispatch(PageStateAction(state: state))
        }
    }

    func selectAtIndex(_ index: Int) {
        if let currencyId = CurrencyManager.shared.getCurrentCurrencyID() {
            CurrencyManager.shared.saveAccountNameWith(currencyId, name: CurrencyManager.shared.getCurrentAccountNames()[index])
        }
    }
}
