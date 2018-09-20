//
//  BLTCardConfirmFingerPrinterCoordinator.swift
//  EOS
//
//  Created peng zhu on 2018/9/13.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift
import NBLCommonModule

protocol BLTCardConfirmFingerPrinterCoordinatorProtocol {
}

protocol BLTCardConfirmFingerPrinterStateManagerProtocol {
    var state: BLTCardConfirmFingerPrinterState { get }
    
    func switchPageState(_ state:PageState)
}

class BLTCardConfirmFingerPrinterCoordinator: BLTCardRootCoordinator {
    var store = Store(
        reducer: BLTCardConfirmFingerPrinterReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
    
    var state: BLTCardConfirmFingerPrinterState {
        return store.state
    }
            
    override func register() {
        Broadcaster.register(BLTCardConfirmFingerPrinterCoordinatorProtocol.self, observer: self)
        Broadcaster.register(BLTCardConfirmFingerPrinterStateManagerProtocol.self, observer: self)
    }
}

extension BLTCardConfirmFingerPrinterCoordinator: BLTCardConfirmFingerPrinterCoordinatorProtocol {
    
}

extension BLTCardConfirmFingerPrinterCoordinator: BLTCardConfirmFingerPrinterStateManagerProtocol {
    func switchPageState(_ state:PageState) {
        self.store.dispatch(PageStateAction(state: state))
    }
}
