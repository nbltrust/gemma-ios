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

protocol BLTCardPowerOnCoordinatorProtocol {
    func dismissVC()

    func popVC()
}

protocol BLTCardPowerOnStateManagerProtocol {
    var state: BLTCardPowerOnState { get }

    func switchPageState(_ state: PageState)
}

class BLTCardPowerOnCoordinator: NavCoordinator {
    var store = Store(
        reducer: BLTCardPowerOnReducer,
        state: nil,
        middleware: [trackingMiddleware]
    )

    var state: BLTCardPowerOnState {
        return store.state
    }

    override class func start(_ root: BaseNavigationController, context: RouteContext? = nil) -> BaseViewController {
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
    func dismissVC() {
        self.rootVC.dismiss(animated: true, completion: nil)
    }

    func popVC() {
        self.rootVC.popViewController(animated: true, nil)
    }

}

extension BLTCardPowerOnCoordinator: BLTCardPowerOnStateManagerProtocol {
    func switchPageState(_ state: PageState) {
        DispatchQueue.main.async {
            self.store.dispatch(PageStateAction(state: state))
        }
    }
}
