//
//  ReceiptCoordinator.swift
//  EOS
//
//  Created zhusongyu on 2018/11/7.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift
import NBLCommonModule

protocol ReceiptCoordinatorProtocol {
}

protocol ReceiptStateManagerProtocol {
    var state: ReceiptState { get }
    
    func switchPageState(_ state:PageState)
}

class ReceiptCoordinator: NavCoordinator {
    var store = Store(
        reducer: gReceiptReducer,
        state: nil,
        middleware:[trackingMiddleware]
    )
    
    var state: ReceiptState {
        return store.state
    }
    
    override class func start(_ root: BaseNavigationController, context:RouteContext? = nil) -> BaseViewController {
        let vc = R.storyboard.receipt.receiptViewController()!
        let coordinator = ReceiptCoordinator(rootVC: root)
        vc.coordinator = coordinator
        coordinator.store.dispatch(RouteContextAction(context: context))
        return vc
    }

    override func register() {
        Broadcaster.register(ReceiptCoordinatorProtocol.self, observer: self)
        Broadcaster.register(ReceiptStateManagerProtocol.self, observer: self)
    }
}

extension ReceiptCoordinator: ReceiptCoordinatorProtocol {
    
}

extension ReceiptCoordinator: ReceiptStateManagerProtocol {
    func switchPageState(_ state:PageState) {
        DispatchQueue.main.async {
            self.store.dispatch(PageStateAction(state: state))
        }
    }
}
