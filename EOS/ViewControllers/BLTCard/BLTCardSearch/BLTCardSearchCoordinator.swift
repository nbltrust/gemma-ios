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
import RxCocoa

protocol BLTCardSearchCoordinatorProtocol {
    func dismissSearchVC()
    
    func pushAfterDeviceConnected()
}

protocol BLTCardSearchStateManagerProtocol {
    var state: BLTCardSearchState { get }
    
    func switchPageState(_ state:PageState)
    
    func searchedADevice(_ device: BLTDevice)
    
    func connectDevice(_ device: BLTDevice, complication: @escaping (Bool, Int) -> Void)
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
    
    func pushAfterDeviceConnected() {
        
    }
}

extension BLTCardSearchCoordinator: BLTCardSearchStateManagerProtocol {
    
    func switchPageState(_ state:PageState) {
        self.store.dispatch(PageStateAction(state: state))
    }
    
    func searchedADevice(_ device: BLTDevice) {
        self.store.dispatch(SetDevicesAction(datas: [device]))
    }
    
    func connectDevice(_ device: BLTDevice, complication: @escaping (Bool, Int) -> Void) {
        BLTWalletIO.connectCard(device.name) { (success, deviceId) in
            complication(success, deviceId)
        }
    }
}
