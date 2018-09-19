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
    
    func pushAfterDeviceConnected(_ deviceInfo: PAEW_DevInfo)
}

protocol BLTCardSearchStateManagerProtocol {
    var state: BLTCardSearchState { get }
    
    func switchPageState(_ state:PageState)
    
    func searchedADevice(_ device: BLTDevice)
    
    func connectDevice(_ device: BLTDevice, complication: @escaping (Bool, Int) -> Void)
    
    func getDeviceInfo(_ complocation: @escaping (Bool, UnsafeMutablePointer<PAEW_DevInfo>?) -> Void)
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
    
    func pushAfterDeviceConnected(_ deviceInfo: PAEW_DevInfo) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate, let homeCoor = appDelegate.appcoordinator?.homeCoordinator {
            self.rootVC.dismiss(animated: true) {
                BLTWalletIO.shareInstance().startHeartBeat()
                if let vc = R.storyboard.leadIn.setWalletViewController() {
                    vc.coordinator = SetWalletCoordinator(rootVC: homeCoor.rootVC)
                    vc.settingType = .wookong
                    vc.deviceInfo = deviceInfo
                    homeCoor.rootVC.pushViewController(vc, animated: true)
                }
            }
        }
    }
}

extension BLTCardSearchCoordinator: BLTCardSearchStateManagerProtocol {
    
    func switchPageState(_ state:PageState) {
        self.store.dispatch(PageStateAction(state: state))
    }
    
    func searchedADevice(_ device: BLTDevice) {
        var devices: [BLTDevice] = self.store.state.devices
        var valid: Bool = true
        devices.forEach { (hisDevice) in
            if hisDevice.name == device.name {
                valid = false
            }
        }
        if valid {
            devices.append(device)
        }
        self.store.dispatch(SetDevicesAction(datas: devices))
    }
    
    func connectDevice(_ device: BLTDevice, complication: @escaping (Bool, Int) -> Void) {
        BLTWalletIO.shareInstance().connectCard(device.name) { (success, deviceId) in
            complication(success, deviceId)
        }
    }
    
    func getDeviceInfo(_ complocation: @escaping (Bool, UnsafeMutablePointer<PAEW_DevInfo>?) -> Void) {
        BLTWalletIO.shareInstance().getDeviceInfo { (success, deviceInfo) in
            complocation(success, deviceInfo)
        }
    }
}
