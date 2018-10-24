//
//  ExchangeToActivateCoordinator.swift
//  EOS
//
//  Created zhusongyu on 2018/9/6.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift
import NBLCommonModule

protocol ExchangeToActivateCoordinatorProtocol {
}

protocol ExchangeToActivateStateManagerProtocol {
    var state: ExchangeToActivateState { get }

    func switchPageState(_ state: PageState)
}

class ExchangeToActivateCoordinator: NavCoordinator {
    var store = Store(
        reducer: gExchangeToActivateReducer,
        state: nil,
        middleware: [trackingMiddleware]
    )

    var state: ExchangeToActivateState {
        return store.state
    }

    override func register() {
        Broadcaster.register(ExchangeToActivateCoordinatorProtocol.self, observer: self)
        Broadcaster.register(ExchangeToActivateStateManagerProtocol.self, observer: self)
    }
}

extension ExchangeToActivateCoordinator: ExchangeToActivateCoordinatorProtocol {

}

extension ExchangeToActivateCoordinator: ExchangeToActivateStateManagerProtocol {
    func switchPageState(_ state: PageState) {
        DispatchQueue.main.async {
            self.store.dispatch(PageStateAction(state: state))
        }
    }
}
