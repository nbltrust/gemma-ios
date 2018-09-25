//
//  AccountListCoordinator.swift
//  EOS
//
//  Created zhusongyu on 2018/7/23.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

protocol AccountListCoordinatorProtocol {
    func dismissListVC()
}

protocol AccountListStateManagerProtocol {
    var state: AccountListState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<AccountListState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState
}

class AccountListCoordinator: NavCoordinator {
    
    lazy var creator = AccountListPropertyActionCreate()
    
    var store = Store<AccountListState>(
        reducer: AccountListReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
    
    override class func start(_ root: BaseNavigationController, context: RouteContext? = nil) -> BaseViewController {
        let vc = R.storyboard.accountList.accountListViewController()!
        let coordinator = AccountListCoordinator(rootVC: root)
        vc.coordinator = coordinator
        coordinator.store.dispatch(RouteContextAction(context: context))

        return vc
    }

}

extension AccountListCoordinator: AccountListCoordinatorProtocol {
    func dismissListVC() {
        self.rootVC.dismiss(animated: true, completion: nil)
    }
}

extension AccountListCoordinator: AccountListStateManagerProtocol {
    var state: AccountListState {
        return store.state
    }
    
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<AccountListState>) -> Subscription<SelectedState>)?
        ) where S.StoreSubscriberStateType == SelectedState {
        store.subscribe(subscriber, transform: transform)
    }
    
}
