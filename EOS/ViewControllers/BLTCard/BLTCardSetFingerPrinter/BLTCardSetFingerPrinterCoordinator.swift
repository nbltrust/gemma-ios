//
//  BLTCardSetFingerPrinterCoordinator.swift
//  EOS
//
//  Created peng zhu on 2018/9/25.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift
import NBLCommonModule
import Async

protocol BLTCardSetFingerPrinterCoordinatorProtocol {
    func dismissVC()
    
    func popVC()
}

protocol BLTCardSetFingerPrinterStateManagerProtocol {
    var state: BLTCardSetFingerPrinterState { get }
    
    func switchPageState(_ state:PageState)
    
    func enrollFingerPrinter(_ state: @escaping EnrollFingerComplication,success: @escaping SuccessedComplication,failed: @escaping FailedComplication)
}

class BLTCardSetFingerPrinterCoordinator: BLTCardRootCoordinator {
    var store = Store(
        reducer: BLTCardSetFingerPrinterReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
    
    var state: BLTCardSetFingerPrinterState {
        return store.state
    }
            
    override func register() {
        Broadcaster.register(BLTCardSetFingerPrinterCoordinatorProtocol.self, observer: self)
        Broadcaster.register(BLTCardSetFingerPrinterStateManagerProtocol.self, observer: self)
    }
}

extension BLTCardSetFingerPrinterCoordinator: BLTCardSetFingerPrinterCoordinatorProtocol {
    func dismissVC() {
        self.rootVC.dismiss(animated: true, completion: nil)
    }
    
    func popVC() {
        self.rootVC.popViewController(animated: true)
    }
}

extension BLTCardSetFingerPrinterCoordinator: BLTCardSetFingerPrinterStateManagerProtocol {
    func switchPageState(_ state:PageState) {
        Async.main {
            self.store.dispatch(PageStateAction(state: state))
        }
    }
    
    func enrollFingerPrinter(_ state: @escaping EnrollFingerComplication, success: @escaping SuccessedComplication, failed: @escaping FailedComplication) {
        BLTWalletIO.shareInstance()?.enrollFingerPrinter(state, success: success, failed: failed)
    }
}
