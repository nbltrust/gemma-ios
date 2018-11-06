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
import SwiftyUserDefaults

protocol PayToActivateCoordinatorProtocol {
    func pushToCreateSuccessVC()
    func pushBackupPrivateKeyVC()
    func dismissCurrentNav(_ entry: UIViewController?)
}

protocol PayToActivateStateManagerProtocol {
    var state: PayToActivateState { get }

    func switchPageState(_ state: PageState)

    func initOrder(_ currencyID:Int64?, completion: @escaping (Bool) -> Void)
    func getBill()
    func askToPay()
    func createWallet(_ inviteCode: String, completion: @escaping (Bool) -> Void)
}

class PayToActivateCoordinator: NavCoordinator {
    var store = Store(
        reducer: gPayToActivateReducer,
        state: nil,
        middleware: [trackingMiddleware]
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

    func pushBackupPrivateKeyVC() {
        let vc = R.storyboard.entry.backupPrivateKeyViewController()!
        let coor = BackupPrivateKeyCoordinator(rootVC: self.rootVC)

        if let entry = self.rootVC.viewControllers[self.rootVC.viewControllers.count - 2] as? EntryViewController {
            coor.state.callback.hadSaveCallback.accept {[weak self] in
                guard let `self` = self else { return }
                self.dismissCurrentNav(entry)
            }
        }
        if let entry = self.rootVC.viewControllers[self.rootVC.viewControllers.count - 3] as? EntryViewController {
            coor.state.callback.hadSaveCallback.accept {[weak self] in
                guard let `self` = self else { return }
                self.dismissCurrentNav(entry)
            }
        }

        vc.coordinator = coor
        self.rootVC.pushViewController(vc, animated: true)
    }
    func dismissCurrentNav(_ entry: UIViewController? = nil) {
        if let entry = entry as? EntryViewController {
            entry.coordinator?.state.callback.endCallback.value?()
            return
        }
        if let vc = self.rootVC.viewControllers[self.rootVC.viewControllers.count - 2] as? EntryViewController {
            vc.coordinator?.state.callback.endCallback.value?()
        }
    }
    func popToEntryVCWithInviteCode(_ inviteCode: String) {
        self.rootVC.viewControllers.forEach { (vc) in
            if let entryVC = vc as? EntryViewController {
                self.popToVC(entryVC)
                entryVC.coordinator?.state.callback.finishEOSCurrencyCallback.value?(inviteCode)
            }
        }
    }
    func popToVC(_ vc: UIViewController) {
        self.rootVC.popToViewController(vc, animated: true)
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
        }) { (_) in
        }
    }

    func initOrder(_ currencyID:Int64?, completion: @escaping (Bool) -> Void) {
        self.rootVC.topViewController?.startLoadingWithMessage(message: R.string.localizable.pay_tips_warning.key.localized())

        var walletName = ""
        var pubkey = ""

        if let name = CurrencyManager.shared.getCurrentAccountName() as? String {
            walletName = name
        }
        let currency = try? WalletCacheService.shared.fetchCurrencyBy(id: currencyID!)
        if let currency = currency {
            pubkey = currency?.pubKey ?? ""
        }

        NBLNetwork.request(target: .initOrder(account: walletName, pubKey: pubkey, platform: "iOS", clientIP:"10.18.14.9", serialNumber: "1"), success: { (data) in
            if let orderID = Order.deserialize(from: data.dictionaryObject) {
                self.store.dispatch(OrderIdAction(orderId: orderID.id))
                NBLNetwork.request(target: .place(orderId: orderID.id), success: { (result) in
                    if let place = Place.deserialize(from: result.dictionaryObject) {
                        let timeInterval = place.timestamp.string
                        var string = "weixin://app/\(place.appid!)/pay/?"
                        string += "nonceStr=\(place.nonceStr!)&"
                        string += "package=Sign%3DWXPay&"
                        string += "partnerId=\(place.partnerid!)&"
                        string += "prepayId=\(place.prepayid!)&"
                        string += "timeStamp=\(UInt32(timeInterval)!)&"
                        string += "sign=\(place.sign!)&signType=SHA1"
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
                }, failure: { (_) in
                    completion(false)
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
        }) { (_) in
            completion(false)
        }
    }

    func askToPay() {
        NBLNetwork.request(target: .getOrder(orderId: self.state.orderId), success: { (data) in
            let payState = data["pay_state"].stringValue
            let state = data["status"].stringValue
            if state != "DONE" {
                self.rootVC.topViewController?.endLoading()
            }

            if payState == "NOTPAY", state == "INIT" {
                var context = ScreenShotAlertContext()
                context.title = R.string.localizable.pay_failed.key.localized()
                context.buttonTitle = R.string.localizable.confirm.key.localized()
                context.imageName = R.image.icFail.name
                context.needCancel = false
                appCoodinator.showGemmaAlert(context)
            } else if payState == "NOTPAY", state == "CLOSED" {
                var context = ScreenShotAlertContext()
                context.desc = R.string.localizable.pay_timeout_tips.key.localized()
                context.title = R.string.localizable.pay_timeout.key.localized()
                context.buttonTitle = R.string.localizable.confirm.key.localized()
                context.imageName = R.image.icTime.name
                context.needCancel = false
                appCoodinator.showGemmaAlert(context)
            } else if payState == "SUCCESS", state == "DONE" {
                self.popToEntryVCWithInviteCode(self.state.orderId)
            } else if payState == "SUCCESS", state == "TOREFUND" {
                var context = ScreenShotAlertContext()
                context.desc = R.string.localizable.price_change_tips.key.localized() + RichStyle.shared.tagText("55 RAM", fontSize: 14, color: UIColor.highlightColor, lineHeight: 16) + "。"
                context.title = R.string.localizable.price_change.key.localized()
                context.buttonTitle = R.string.localizable.pay_sure.key.localized()
                context.imageName = R.image.icMoney.name
                context.needCancel = true
                context.sureShot = {
                    if let vc = self.rootVC.topViewController as? ActivateViewController, let payVC = vc.viewControllers[0] as? PayToActivateViewController {
                        payVC.nextClick([:])
                    }
                }
                appCoodinator.showGemmaAlert(context)
            } else if payState == "REFUND" {
                var context = ScreenShotAlertContext()
                context.title = R.string.localizable.refund_title.key.localized()
                context.buttonTitle = R.string.localizable.confirm.key.localized()
                context.imageName = R.image.icFail.name
                context.needCancel = false
                appCoodinator.showGemmaAlert(context)
            } else if payState == "CLOSED" {
                var context = ScreenShotAlertContext()
                context.title = R.string.localizable.closed.key.localized()
                context.buttonTitle = R.string.localizable.confirm.key.localized()
                context.imageName = R.image.icFail.name
                context.needCancel = false
                appCoodinator.showGemmaAlert(context)
            } else if payState == "USERPAYING" {
                var context = ScreenShotAlertContext()
                context.title = R.string.localizable.userpaying.key.localized()
                context.buttonTitle = R.string.localizable.confirm.key.localized()
                context.imageName = R.image.icFail.name
                context.needCancel = false
                appCoodinator.showGemmaAlert(context)
            } else if payState == "PAYERROR" {
                var context = ScreenShotAlertContext()
                context.title = R.string.localizable.payerror.key.localized()
                context.buttonTitle = R.string.localizable.confirm.key.localized()
                context.imageName = R.image.icFail.name
                context.needCancel = false
                appCoodinator.showGemmaAlert(context)
            }
        }, error: { (code) in
            self.rootVC.topViewController?.endLoading()
            if let gemmaerror = GemmaError.NBLNetworkErrorCode(rawValue: code) {
                let error = GemmaError.NBLCode(code: gemmaerror)
                showFailTop(error.localizedDescription)
            } else {
                showFailTop(R.string.localizable.error_unknow.key.localized())
            }
        }) { (_) in
            self.rootVC.topViewController?.endLoading()
        }
    }

    func createWallet(_ inviteCode: String, completion: @escaping (Bool) -> Void) {
        var walletName = ""
        var password = ""
        var prompt = ""
        Broadcaster.notify(EntryViewController.self) { (vc) in
            walletName = vc.registerView.nameView.textField.text!
            password = vc.registerView.passwordView.textField.text!
            prompt = vc.registerView.passwordPromptView.textField.text!
        }
        NBLNetwork.request(target: .createAccount(type: .gemma, account: walletName, pubKey: WalletManager.shared.currentPubKey, invitationCode: inviteCode, validation: nil), success: { (data) in
            self.rootVC.topViewController?.endLoading()
            WalletManager.shared.saveWallket(walletName, password: password, hint: prompt, isImport: false, txID: data["txId"].stringValue, invitationCode: inviteCode)
            self.pushBackupPrivateKeyVC()
        }, error: { (code) in
            if let gemmaerror = GemmaError.NBLNetworkErrorCode(rawValue: code) {
                let error = GemmaError.NBLCode(code: gemmaerror)
                if code == GemmaError.NBLNetworkErrorCode.chainFailedCode.rawValue {
                    self.store.dispatch(NumsAction(nums: self.state.nums))
                    if self.state.nums <= 3 {
                        self.createWallet(self.state.orderId, completion: { (_) in

                        })
                    } else {
                        showFailTop(R.string.localizable.error_chain_fail.key.localized())
                    }
                } else if code == GemmaError.NBLNetworkErrorCode.parameterWrongCode.rawValue ||
                    code == GemmaError.NBLNetworkErrorCode.invitecodeInexistenceCode.rawValue ||
                    code == GemmaError.NBLNetworkErrorCode.invitecodeRegiteredCode.rawValue {
                    showFailTop(error.localizedDescription + R.string.localizable.connect_customer_service.key.localized())
                } else {
                    showFailTop(error.localizedDescription + R.string.localizable.refund_money_suf.key.localized())
                }
            } else {
                showFailTop(R.string.localizable.error_unknow.key.localized())
            }

        }) { (_) in
        }
    }

    func switchPageState(_ state: PageState) {
        DispatchQueue.main.async {
            self.store.dispatch(PageStateAction(state: state))
        }
    }
}
