//
//  PayToActivateCoordinator.swift
//  EOS
//
//  Created zhusongyu on 2018/9/6.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift
import SwiftNotificationCenter
import FGRoute
import Async

protocol PayToActivateCoordinatorProtocol {
}

protocol PayToActivateStateManagerProtocol {
    var state: PayToActivateState { get }
    
    func switchPageState(_ state:PageState)
    
    func initOrder()
    func getBill()
}

class PayToActivateCoordinator: EntryRootCoordinator {
    var store = Store(
        reducer: PayToActivateReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
    
    var state: PayToActivateState {
        return store.state
    }
            
    override func register() {
        Broadcaster.register(PayToActivateCoordinatorProtocol.self, observer: self)
        Broadcaster.register(PayToActivateStateManagerProtocol.self, observer: self)
    }
}

extension PayToActivateCoordinator: PayToActivateCoordinatorProtocol {
    
}

extension PayToActivateCoordinator: PayToActivateStateManagerProtocol {
    func getBill() {
        NBLNetwork.request(target: .getBill, success: { (data) in
            if let bill = Bill.deserialize(from: data.dictionaryObject) {
                self.store.dispatch(BillAction(data: bill))
            }
        }, error: { (code) in
            if let gemmaerror = GemmaError.NBLNetworkErrorCode(rawValue: code) {
                let error = GemmaError.NBLCode(code: gemmaerror)
                showFailTop(error.localizedDescription)
            } else {
                showFailTop(R.string.localizable.error_unknow.key.localized())
            }
        }) { (error) in
            showFailTop(R.string.localizable.request_failed.key.localized())
        }
    }
    
    func initOrder() {
        var walletName = ""
        Broadcaster.notify(EntryViewController.self) { (vc) in
            walletName = vc.registerView.nameView.textField.text!
        }
        NBLNetwork.request(target: .initOrder(account: walletName, pubKey: WalletManager.shared.currentPubKey, platform: "iOS", client_ip:"FGRoute.getIPAddress()", serial_number: "1"), success: { (data) in
            if let orderID = Order.deserialize(from: data.dictionaryObject) {
                NBLNetwork.request(target: .place(orderId: orderID._id), success: { (result) in
                    if let place = Place.deserialize(from: result.dictionaryObject) {
                        let timeInterval = Date().timeIntervalSince1970
                        let string = "weixin://app/\(place.appid!)/pay/?nonceStr=\(place.nonce_str!)&package=Sign%3DWXPay&partnerId=\(place.mch_id!)&prepayId=\(place.prepay_id!)&timeStamp=\(UInt32(timeInterval))&sign=\(place.sign!)&signType=SHA1"
                        MonkeyKingManager.shared.wechatPay(urlString: string, resultCallback: { (success) in
                            
                        })
                    }
                }, error: { (code) in
                    if let gemmaerror = GemmaError.NBLNetworkErrorCode(rawValue: code) {
                        let error = GemmaError.NBLCode(code: gemmaerror)
                        showFailTop(error.localizedDescription)
                    } else {
                        showFailTop(R.string.localizable.error_unknow.key.localized())
                    }
                }, failure: { (error) in
                    showFailTop(R.string.localizable.request_failed.key.localized())
                })
                
            }
        }, error: { (code) in
            if let gemmaerror = GemmaError.NBLNetworkErrorCode(rawValue: code) {
                let error = GemmaError.NBLCode(code: gemmaerror)
                showFailTop(error.localizedDescription)
            } else {
                showFailTop(R.string.localizable.error_unknow.key.localized())
            }
        }) { (error) in
            showFailTop(R.string.localizable.request_failed.key.localized())
        }
    }
    
    func switchPageState(_ state:PageState) {
        Async.main {
            self.store.dispatch(PageStateAction(state: state))
        }
    }
}
