//
//  VerifyPriKeyCoordinator.swift
//  EOS
//
//  Created zhusongyu on 2018/9/25.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift
import NBLCommonModule
import Async

protocol VerifyPriKeyCoordinatorProtocol {
}

protocol VerifyPriKeyStateManagerProtocol {
    var state: VerifyPriKeyState { get }
    
    func switchPageState(_ state:PageState)
}

class VerifyPriKeyCoordinator: NavCoordinator {
    var store = Store(
        reducer: VerifyPriKeyReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
    
    var state: VerifyPriKeyState {
        return store.state
    }
            
    override func register() {
        Broadcaster.register(VerifyPriKeyCoordinatorProtocol.self, observer: self)
        Broadcaster.register(VerifyPriKeyStateManagerProtocol.self, observer: self)
    }
}

extension VerifyPriKeyCoordinator: VerifyPriKeyCoordinatorProtocol {
    
}

extension VerifyPriKeyCoordinator: VerifyPriKeyStateManagerProtocol {
    func switchPageState(_ state:PageState) {
        Async.main {
            self.store.dispatch(PageStateAction(state: state))
        }
    }
}
