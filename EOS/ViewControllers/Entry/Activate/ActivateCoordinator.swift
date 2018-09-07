//
//  ActivateCoordinator.swift
//  EOS
//
//  Created zhusongyu on 2018/9/6.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift
import SwiftNotificationCenter
import Async

protocol ActivateCoordinatorProtocol {
}

protocol ActivateStateManagerProtocol {
    var state: ActivateState { get }
    
    func switchPageState(_ state:PageState)
}

class ActivateCoordinator: HomeRootCoordinator {
    var store = Store(
        reducer: ActivateReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
    
    var state: ActivateState {
        return store.state
    }
            
    override func register() {
        Broadcaster.register(ActivateCoordinatorProtocol.self, observer: self)
        Broadcaster.register(ActivateStateManagerProtocol.self, observer: self)
    }
}

extension ActivateCoordinator: ActivateCoordinatorProtocol {
    
}

extension ActivateCoordinator: ActivateStateManagerProtocol {
    func switchPageState(_ state:PageState) {
        Async.main {
            self.store.dispatch(PageStateAction(state: state))
        }
    }
}
