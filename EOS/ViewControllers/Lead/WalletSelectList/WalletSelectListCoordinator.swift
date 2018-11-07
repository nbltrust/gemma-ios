//
//  WalletSelectListCoordinator.swift
//  EOS
//
//  Created peng zhu on 2018/11/1.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift
import NBLCommonModule

protocol WalletSelectListCoordinatorProtocol {
    func popVC()
}

protocol WalletSelectListStateManagerProtocol {
    var state: WalletSelectListState { get }
    
    func switchPageState(_ state:PageState)
}

class WalletSelectListCoordinator: NavCoordinator {
    var store = Store(
        reducer: gWalletSelectListReducer,
        state: nil,
        middleware:[trackingMiddleware]
    )
    
    var state: WalletSelectListState {
        return store.state
    }
    
    override class func start(_ root: BaseNavigationController, context:RouteContext? = nil) -> BaseViewController {
        let vc = R.storyboard.leadIn.walletSelectListViewController()!
        let coordinator = WalletSelectListCoordinator(rootVC: root)
        vc.coordinator = coordinator
        coordinator.store.dispatch(RouteContextAction(context: context))
        return vc
    }

    override func register() {
        Broadcaster.register(WalletSelectListCoordinatorProtocol.self, observer: self)
        Broadcaster.register(WalletSelectListStateManagerProtocol.self, observer: self)
    }
}

extension WalletSelectListCoordinator: WalletSelectListCoordinatorProtocol {
    func popVC() {
        self.rootVC.popViewController(animated: true)
    }
}

extension WalletSelectListCoordinator: WalletSelectListStateManagerProtocol {
    func switchPageState(_ state:PageState) {
        DispatchQueue.main.async {
            self.store.dispatch(PageStateAction(state: state))
        }
    }
}
