//
//  BLTInitTypeSelectCoordinator.swift
//  EOS
//
//  Created peng zhu on 2018/11/27.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift
import NBLCommonModule

protocol BLTInitTypeSelectCoordinatorProtocol {
    func dismissNav(_ complication: @escaping () -> Void)
}

protocol BLTInitTypeSelectStateManagerProtocol {
    var state: BLTInitTypeSelectState { get }
    
    func switchPageState(_ state: PageState)
}

class BLTInitTypeSelectCoordinator: NavCoordinator {
    var store = Store(
        reducer: gBLTInitTypeSelectReducer,
        state: nil,
        middleware: [trackingMiddleware]
    )
    
    var state: BLTInitTypeSelectState {
        return store.state
    }
    
    override class func start(_ root: BaseNavigationController, context:RouteContext? = nil) -> BaseViewController {
        let currentVC = R.storyboard.bltCard.bltInitTypeSelectViewController()!
        let coordinator = BLTInitTypeSelectCoordinator(rootVC: root)
        currentVC.coordinator = coordinator
        coordinator.store.dispatch(RouteContextAction(context: context))
        return currentVC
    }

    override func register() {
        Broadcaster.register(BLTInitTypeSelectCoordinatorProtocol.self, observer: self)
        Broadcaster.register(BLTInitTypeSelectStateManagerProtocol.self, observer: self)
    }
}

extension BLTInitTypeSelectCoordinator: BLTInitTypeSelectCoordinatorProtocol {
    func dismissNav(_ complication: @escaping () -> Void) {
        self.rootVC.dismiss(animated: true, completion: complication)
    }
}

extension BLTInitTypeSelectCoordinator: BLTInitTypeSelectStateManagerProtocol {
    func switchPageState(_ state: PageState) {
        DispatchQueue.main.async {
            self.store.dispatch(PageStateAction(state: state))
        }
    }
}
