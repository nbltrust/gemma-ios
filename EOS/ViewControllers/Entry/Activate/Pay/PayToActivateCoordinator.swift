//
//  PayToActivateCoordinator.swift
//  EOS
//
//  Created zhusongyu on 2018/9/6.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift
import SwiftNotificationCenter
import Async

protocol PayToActivateCoordinatorProtocol {
}

protocol PayToActivateStateManagerProtocol {
    var state: PayToActivateState { get }
    
    func switchPageState(_ state:PageState)
}

class PayToActivateCoordinator: EntryRootCoordinator {
    var store = Store(
        reducer: PayToActivateReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
    
    var state: PayToActivateState {
        return store.state
    }
            
    override func register() {
        Broadcaster.register(PayToActivateCoordinatorProtocol.self, observer: self)
        Broadcaster.register(PayToActivateStateManagerProtocol.self, observer: self)
    }
}

extension PayToActivateCoordinator: PayToActivateCoordinatorProtocol {
    
}

extension PayToActivateCoordinator: PayToActivateStateManagerProtocol {
    func switchPageState(_ state:PageState) {
        Async.main {
            self.store.dispatch(PageStateAction(state: state))
        }
    }
}
