//
//  BLTCardPowerOnCoordinator.swift
//  EOS
//
//  Created peng zhu on 2018/9/30.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift
import NBLCommonModule
import Async

protocol BLTCardPowerOnCoordinatorProtocol {
}

protocol BLTCardPowerOnStateManagerProtocol {
    var state: BLTCardPowerOnState { get }
    
    func switchPageState(_ state:PageState)
}

class BLTCardPowerOnCoordinator: NavCoordinator {
    var store = Store(
        reducer: BLTCardPowerOnReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
    
    var state: BLTCardPowerOnState {
        return store.state
    }
    
    override class func start(_ root: BaseNavigationController, context:RouteContext? = nil) -> BaseViewController {
        let vc = R.storyboard.bltCard.bltCardPowerOnViewController()!
        let coordinator = BLTCardPowerOnCoordinator(rootVC: root)
        vc.coordinator = coordinator
        coordinator.store.dispatch(RouteContextAction(context: context))
        return vc
    }

    override func register() {
        Broadcaster.register(BLTCardPowerOnCoordinatorProtocol.self, observer: self)
        Broadcaster.register(BLTCardPowerOnStateManagerProtocol.self, observer: self)
    }
}

extension BLTCardPowerOnCoordinator: BLTCardPowerOnCoordinatorProtocol {
    
}

extension BLTCardPowerOnCoordinator: BLTCardPowerOnStateManagerProtocol {
    func switchPageState(_ state:PageState) {
        Async.main {
            self.store.dispatch(PageStateAction(state: state))
        }
    }
}
