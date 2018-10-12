//
//  DeleteFingerCoordinator.swift
//  EOS
//
//  Created zhusongyu on 2018/10/12.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift
import NBLCommonModule
import Async

protocol DeleteFingerCoordinatorProtocol {
}

protocol DeleteFingerStateManagerProtocol {
    var state: DeleteFingerState { get }
    
    func switchPageState(_ state:PageState)
}

class DeleteFingerCoordinator: NavCoordinator {
    var store = Store(
        reducer: DeleteFingerReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
    
    var state: DeleteFingerState {
        return store.state
    }
    
    override class func start(_ root: BaseNavigationController, context:RouteContext? = nil) -> BaseViewController {
        let vc = R.storyboard.wallet.deleteFingerViewController()!
        let coordinator = DeleteFingerCoordinator(rootVC: root)
        vc.coordinator = coordinator
        coordinator.store.dispatch(RouteContextAction(context: context))
        return vc
    }

    override func register() {
        Broadcaster.register(DeleteFingerCoordinatorProtocol.self, observer: self)
        Broadcaster.register(DeleteFingerStateManagerProtocol.self, observer: self)
    }
}

extension DeleteFingerCoordinator: DeleteFingerCoordinatorProtocol {
    
}

extension DeleteFingerCoordinator: DeleteFingerStateManagerProtocol {
    func switchPageState(_ state:PageState) {
        Async.main {
            self.store.dispatch(PageStateAction(state: state))
        }
    }
}
