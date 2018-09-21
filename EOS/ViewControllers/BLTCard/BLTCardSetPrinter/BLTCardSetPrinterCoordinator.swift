//
//  BLTCardSetPrinterCoordinator.swift
//  EOS
//
//  Created peng zhu on 2018/9/20.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift
import NBLCommonModule
import Async

protocol BLTCardSetPrinterCoordinatorProtocol {
}

protocol BLTCardSetPrinterStateManagerProtocol {
    var state: BLTCardSetPrinterState { get }
    
    func switchPageState(_ state:PageState)    
}

class BLTCardSetPrinterCoordinator: BLTCardRootCoordinator {
    var store = Store(
        reducer: BLTCardSetPrinterReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
    
    var state: BLTCardSetPrinterState {
        return store.state
    }
            
    override func register() {
        Broadcaster.register(BLTCardSetPrinterCoordinatorProtocol.self, observer: self)
        Broadcaster.register(BLTCardSetPrinterStateManagerProtocol.self, observer: self)
    }
}

extension BLTCardSetPrinterCoordinator: BLTCardSetPrinterCoordinatorProtocol {
    
}

extension BLTCardSetPrinterCoordinator: BLTCardSetPrinterStateManagerProtocol {
    func switchPageState(_ state:PageState) {
        Async.main {
            self.store.dispatch(PageStateAction(state: state))
        }
    }
}
