//
//  WalletDetailCoordinator.swift
//  EOS
//
//  Created zhusongyu on 2018/10/12.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift
import NBLCommonModule
import Async

protocol WalletDetailCoordinatorProtocol {
}

protocol WalletDetailStateManagerProtocol {
    var state: WalletDetailState { get }
    
    func switchPageState(_ state:PageState)
}

class WalletDetailCoordinator: NavCoordinator {
    var store = Store(
        reducer: WalletDetailReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
    
    var state: WalletDetailState {
        return store.state
    }
    
    override class func start(_ root: BaseNavigationController, context:RouteContext? = nil) -> BaseViewController {
        let vc = R.storyboard.wallet.walletDetailViewController()!
        let coordinator = WalletDetailCoordinator(rootVC: root)
        vc.coordinator = coordinator
        coordinator.store.dispatch(RouteContextAction(context: context))
        return vc
    }

    override func register() {
        Broadcaster.register(WalletDetailCoordinatorProtocol.self, observer: self)
        Broadcaster.register(WalletDetailStateManagerProtocol.self, observer: self)
    }
}

extension WalletDetailCoordinator: WalletDetailCoordinatorProtocol {
    
}

extension WalletDetailCoordinator: WalletDetailStateManagerProtocol {
    func switchPageState(_ state:PageState) {
        Async.main {
            self.store.dispatch(PageStateAction(state: state))
        }
    }
}
