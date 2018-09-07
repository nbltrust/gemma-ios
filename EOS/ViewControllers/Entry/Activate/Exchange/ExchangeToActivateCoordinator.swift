//
//  ExchangeToActivateCoordinator.swift
//  EOS
//
//  Created zhusongyu on 2018/9/6.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift
import SwiftNotificationCenter
import Async

protocol ExchangeToActivateCoordinatorProtocol {
}

protocol ExchangeToActivateStateManagerProtocol {
    var state: ExchangeToActivateState { get }
    
    func switchPageState(_ state:PageState)
}

class ExchangeToActivateCoordinator: HomeRootCoordinator {
    var store = Store(
        reducer: ExchangeToActivateReducer,
        state: nil,
        middleware:[TrackingMiddleware]
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
    func switchPageState(_ state:PageState) {
        Async.main {
            self.store.dispatch(PageStateAction(state: state))
        }
    }
}
