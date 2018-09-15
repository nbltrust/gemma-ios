//
//  AccountSetCoordinator.swift
//  EOS
//
//  Created peng zhu on 2018/9/13.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift
import SwiftNotificationCenter

protocol AccountSetCoordinatorProtocol {
}

protocol AccountSetStateManagerProtocol {
    var state: AccountSetState { get }
    
    func switchPageState(_ state:PageState)
}

class AccountSetCoordinator: BLTCardRootCoordinator {
    var store = Store(
        reducer: AccountSetReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
    
    var state: AccountSetState {
        return store.state
    }
            
    override func register() {
        Broadcaster.register(AccountSetCoordinatorProtocol.self, observer: self)
        Broadcaster.register(AccountSetStateManagerProtocol.self, observer: self)
    }
}

extension AccountSetCoordinator: AccountSetCoordinatorProtocol {
    
}

extension AccountSetCoordinator: AccountSetStateManagerProtocol {
    func switchPageState(_ state:PageState) {
        self.store.dispatch(PageStateAction(state: state))
    }
}
