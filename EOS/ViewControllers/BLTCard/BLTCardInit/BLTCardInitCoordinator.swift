//
//  BLTCardInitCoordinator.swift
//  EOS
//
//  Created peng zhu on 2018/9/13.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift
import NBLCommonModule

protocol BLTCardInitCoordinatorProtocol {
}

protocol BLTCardInitStateManagerProtocol {
    var state: BLTCardInitState { get }
    
    func switchPageState(_ state:PageState)
}

class BLTCardInitCoordinator: BLTCardRootCoordinator {
    var store = Store(
        reducer: BLTCardInitReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
    
    var state: BLTCardInitState {
        return store.state
    }
            
    override func register() {
        Broadcaster.register(BLTCardInitCoordinatorProtocol.self, observer: self)
        Broadcaster.register(BLTCardInitStateManagerProtocol.self, observer: self)
    }
}

extension BLTCardInitCoordinator: BLTCardInitCoordinatorProtocol {
    
}

extension BLTCardInitCoordinator: BLTCardInitStateManagerProtocol {
    func switchPageState(_ state:PageState) {
        self.store.dispatch(PageStateAction(state: state))
    }
}
