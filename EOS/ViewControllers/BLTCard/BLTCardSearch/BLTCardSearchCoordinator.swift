//
//  BLTCardSearchCoordinator.swift
//  EOS
//
//  Created peng zhu on 2018/9/13.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift
import SwiftNotificationCenter

protocol BLTCardSearchCoordinatorProtocol {
    func dismissSearchVC()
}

protocol BLTCardSearchStateManagerProtocol {
    var state: BLTCardSearchState { get }
    
    func switchPageState(_ state:PageState)
}

class BLTCardSearchCoordinator: BLTCardRootCoordinator {
    var store = Store(
        reducer: BLTCardSearchReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
    
    var state: BLTCardSearchState {
        return store.state
    }
            
    override func register() {
        Broadcaster.register(BLTCardSearchCoordinatorProtocol.self, observer: self)
        Broadcaster.register(BLTCardSearchStateManagerProtocol.self, observer: self)
    }
}

extension BLTCardSearchCoordinator: BLTCardSearchCoordinatorProtocol {
    func dismissSearchVC() {
        self.rootVC.dismiss(animated: true, completion: nil)
    }
}

extension BLTCardSearchCoordinator: BLTCardSearchStateManagerProtocol {
    func switchPageState(_ state:PageState) {
        self.store.dispatch(PageStateAction(state: state))
    }
}
