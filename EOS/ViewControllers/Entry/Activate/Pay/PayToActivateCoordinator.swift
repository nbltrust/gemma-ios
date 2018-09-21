//
//  PayToActivateCoordinator.swift
//  EOS
//
//  Created zhusongyu on 2018/9/6.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift
import NBLCommonModule
import Async

protocol PayToActivateCoordinatorProtocol {
    func pushToCreateSuccessVC()
}

protocol PayToActivateStateManagerProtocol {
    var state: PayToActivateState { get }
    
    func switchPageState(_ state:PageState)
    
    func initOrder(completion: @escaping (Bool) -> ())
    func getBill()
    func askToPay()
    func createWallet(_ inviteCode: String, completion: @escaping (Bool) -> ())
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
    func pushToCreateSuccessVC() {
        let createCompleteVC = R.storyboard.entry.creatationCompleteViewController()
        let coordinator = CreatationCompleteCoordinator(rootVC: self.rootVC)
        createCompleteVC?.coordinator = coordinator
        self.rootVC.pushViewController(createCompleteVC!, animated: true)
    }
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
    
    func initOrder(completion: @escaping (Bool) -> ()) {
        self.rootVC.topViewController?.startLoadingWithMessage(message: R.string.localizable.pay_tips_warning.key.localized())

        var walletName = ""
        Broadcaster.notify(EntryViewController.self) { (vc) in
            walletName = vc.registerView.nameView.textField.text!
        }
        NBLNetwork.request(target: .initOrder(account: walletName, pubKey: WalletManager.shared.currentPubKey, platform: "iOS", client_ip:"10.18.14.9", serial_number: "1"), success: { (data) in
            if let orderID = Order.deserialize(from: data.dictionaryObject) {
                self.store.dispatch(OrderIdAction(orderId: orderID._id))
                NBLNetwork.request(target: .place(orderId: orderID._id), success: { (result) in
                    if let place = Place.deserialize(from: result.dictionaryObject) {
                        let timeInterval = Date().timeIntervalSince1970
                        let string = "weixin://app/\(place.appid!)/pay/?nonceStr=\(place.nonceStr!)&package=Sign%3DWXPay&partnerId=\(place.partnerid!)&prepayId=\(place.prepayid!)&timeStamp=\(UInt32(timeInterval))&sign=\(place.sign!)&signType=SHA1"
                        MonkeyKingManager.shared.wechatPay(urlString: string, resultCallback: { (success) in
                            self.state.pageState.accept(.initial)
                            self.askToPay()
                            completion(success)
                        })
                    } else {
                        completion(false)
                    }
                }, error: { (code) in
                    completion(false)
                    if let gemmaerror = GemmaError.NBLNetworkErrorCode(rawValue: code) {
                        let error = GemmaError.NBLCode(code: gemmaerror)
                        showFailTop(error.localizedDescription)
                    } else {
                        showFailTop(R.string.localizable.error_unknow.key.localized())
                    }
                }, failure: { (error) in
                    completion(false)
                    showFailTop(R.string.localizable.request_failed.key.localized())
                })
                
            }
        }, error: { (code) in
            completion(false)
            if let gemmaerror = GemmaError.NBLNetworkErrorCode(rawValue: code) {
                let error = GemmaError.NBLCode(code: gemmaerror)
                showFailTop(error.localizedDescription)
            } else {
                showFailTop(R.string.localizable.error_unknow.key.localized())
            }
        }) { (error) in
            completion(false)
            showFailTop(R.string.localizable.request_failed.key.localized())
        }
    }
    
    func askToPay() {
        NBLNetwork.request(target: .getOrder(orderId: self.state.orderId), success: { (data) in
            self.rootVC.topViewController?.endLoading()
            let payState = data["pay_state"].stringValue
            let state = data["status"].stringValue
            if payState == "NOTPAY", state == "INIT" {
                
            } else if payState == "NOTPAY", state == "CLOSED" {
                
            } else if payState == "SUCCESS", state == "DONE" {
                self.createWallet(self.state.orderId, completion: { (data) in
                    
                })
            } else if payState == "SUCCESS", state == "TOREFUND" {
                
            } else if payState == "REFUND" {
                
            } else if payState == "CLOSED" {
                
            } else if payState == "USERPAYING" {
                
            } else if payState == "PAYERROR" {
                
            }
        }, error: { (code) in
            self.rootVC.topViewController?.endLoading()
            if let gemmaerror = GemmaError.NBLNetworkErrorCode(rawValue: code) {
                let error = GemmaError.NBLCode(code: gemmaerror)
                showFailTop(error.localizedDescription)
            } else {
                showFailTop(R.string.localizable.error_unknow.key.localized())
            }
        }) { (error) in
            self.rootVC.topViewController?.endLoading()
            showFailTop(R.string.localizable.request_failed.key.localized())
        }
    }
    
    func createWallet(_ inviteCode: String, completion: @escaping (Bool) -> ()) {
        self.rootVC.topViewController?.startLoading()
        var walletName = ""
        var password = ""
        var prompt = ""
        Broadcaster.notify(EntryViewController.self) { (vc) in
            walletName = vc.registerView.nameView.textField.text!
            password = vc.registerView.passwordView.textField.text!
            prompt = vc.registerView.passwordPromptView.textField.text!
        }
        NBLNetwork.request(target: .createAccount(account: walletName, pubKey: WalletManager.shared.currentPubKey, invitationCode: inviteCode, hash: ""), success: { (data) in
            self.rootVC.topViewController?.endLoading()
            WalletManager.shared.saveWallket(walletName, password: password, hint: prompt, isImport: false, txID: data["txId"].stringValue, invitationCode:inviteCode)
            self.pushToCreateSuccessVC()
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
