//
//  BLTCardConfirmPinCoordinator.swift
//  EOS
//
//  Created peng zhu on 2018/9/13.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift
import NBLCommonModule

protocol BLTCardConfirmPinCoordinatorProtocol {
}

protocol BLTCardConfirmPinStateManagerProtocol {
    var state: BLTCardConfirmPinState { get }

    func switchPageState(_ state: PageState)
}

class BLTCardConfirmPinCoordinator: BLTCardRootCoordinator {
    var store = Store(
        reducer: BLTCardConfirmPinReducer,
        state: nil,
        middleware: [trackingMiddleware]
    )

    var state: BLTCardConfirmPinState {
        return store.state
    }

    override func register() {
        Broadcaster.register(BLTCardConfirmPinCoordinatorProtocol.self, observer: self)
        Broadcaster.register(BLTCardConfirmPinStateManagerProtocol.self, observer: self)
    }
}

extension BLTCardConfirmPinCoordinator: BLTCardConfirmPinCoordinatorProtocol {

}

extension BLTCardConfirmPinCoordinator: BLTCardConfirmPinStateManagerProtocol {
    func switchPageState(_ state: PageState) {
        self.store.dispatch(PageStateAction(state: state))
    }
}
