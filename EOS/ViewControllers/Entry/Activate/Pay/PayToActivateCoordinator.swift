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
    func place(_ currencyID:Int64?)
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
    func popToRootVC() {
        self.rootVC.popToRootViewController(animated: true)
    }
    func popToVC(_ vc: UIViewController) {
        self.rootVC.popToViewController(vc, animated: true)
    }
}

extension PayToActivateCoordinator: PayToActivateStateManagerProtocol {
    func getBill() {
        NBLNetwork.request(target: .getBill, success: {[weak self] (data) in
            guard let `self` = self else { return }
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

        NBLNetwork.request(target: .initOrder(account: walletName, pubKey: pubkey, platform: "iOS", clientIP:"10.18.14.9", serialNumber: "1"), success: {[weak self] (data) in
            guard let `self` = self else { return }
            if let order = Order.deserialize(from: data.dictionaryObject) {
                self.store.dispatch(OrderAction(order: order))
            }
            self.rootVC.topViewController?.endLoading()
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

    func place(_ currencyID:Int64?) {
        self.rootVC.topViewController?.startLoadingWithMessage(message: R.string.localizable.pay_tips_warning.key.localized())
        let orderID = self.state.orderId.value
        NBLNetwork.request(target: .place(orderId: orderID), success: {[weak self] (result) in
            guard let `self` = self else { return }
            if let place = Place.deserialize(from: result.dictionaryObject) {
                let timeInterval = place.timestamp.string
                let actionId = place.actionId.string
                if let key = CurrencyManager.shared.getAccountNameWith(currencyID) {
                    Defaults[key] = actionId
                }
                if let currencyid = currencyID {
                    CurrencyManager.shared.saveActived(currencyid, actived: .doActive)
                }
                var string = "weixin://app/\(place.appid!)/pay/?"
                string += "nonceStr=\(place.nonceStr!)&"
                string += "package=Sign%3DWXPay&"
                string += "partnerId=\(place.partnerid!)&"
                string += "prepayId=\(place.prepayid!)&"
                string += "timeStamp=\(UInt32(timeInterval)!)&"
                string += "sign=\(place.sign!)&signType=SHA1"
                self.state.pageState.accept(.refresh(type: .manual))
                MonkeyKingManager.shared.wechatPay(urlString: string, resultCallback: {[weak self] (success) in
                    guard let `self` = self else { return }
                    self.state.pageState.accept(.initial)
                    self.askToPay(currencyID)
                })
            } else {
                showFailTop(R.string.localizable.error_unknow.key.localized())
            }
        }, error: { (code) in
            if let gemmaerror = GemmaError.NBLNetworkErrorCode(rawValue: code) {
                let error = GemmaError.NBLCode(code: gemmaerror)
                showFailTop(error.localizedDescription)
            } else {
                showFailTop(R.string.localizable.error_unknow.key.localized())
            }
        }, failure: { (_) in
        })
    }

    func askToPay(_ currencyID:Int64?) {
        NBLNetwork.request(target: .getOrder(orderId: self.state.orderId.value), success: {[weak self] (data) in
            guard let `self` = self else { return }
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
                if let currencyid = currencyID {
                    CurrencyManager.shared.saveActived(currencyid, actived: .nonActived)
                }
            } else if payState == "NOTPAY", state == "CLOSED" {
                var context = ScreenShotAlertContext()
                context.desc = R.string.localizable.pay_timeout_tips.key.localized()
                context.title = R.string.localizable.pay_timeout.key.localized()
                context.buttonTitle = R.string.localizable.confirm.key.localized()
                context.imageName = R.image.ic_time.name
                context.needCancel = false
                appCoodinator.showGemmaAlert(context)
                if let currencyid = currencyID {
                    CurrencyManager.shared.saveActived(currencyid, actived: .nonActived)
                }
            } else if payState == "SUCCESS", state == "DONE" {
                self.popToRootVC()
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
                if let currencyid = currencyID {
                    CurrencyManager.shared.saveActived(currencyid, actived: .nonActived)
                }
            } else if payState == "REFUND" {
                var context = ScreenShotAlertContext()
                context.title = R.string.localizable.refund_title.key.localized()
                context.buttonTitle = R.string.localizable.confirm.key.localized()
                context.imageName = R.image.icFail.name
                context.needCancel = false
                appCoodinator.showGemmaAlert(context)
                if let currencyid = currencyID {
                    CurrencyManager.shared.saveActived(currencyid, actived: .nonActived)
                }
            } else if payState == "CLOSED" {
                var context = ScreenShotAlertContext()
                context.title = R.string.localizable.closed.key.localized()
                context.buttonTitle = R.string.localizable.confirm.key.localized()
                context.imageName = R.image.icFail.name
                context.needCancel = false
                appCoodinator.showGemmaAlert(context)
                if let currencyid = currencyID {
                    CurrencyManager.shared.saveActived(currencyid, actived: .nonActived)
                }
            } else if payState == "USERPAYING" {
                var context = ScreenShotAlertContext()
                context.title = R.string.localizable.userpaying.key.localized()
                context.buttonTitle = R.string.localizable.confirm.key.localized()
                context.imageName = R.image.icFail.name
                context.needCancel = false
                appCoodinator.showGemmaAlert(context)
                if let currencyid = currencyID {
                    CurrencyManager.shared.saveActived(currencyid, actived: .nonActived)
                }
            } else if payState == "PAYERROR" {
                var context = ScreenShotAlertContext()
                context.title = R.string.localizable.payerror.key.localized()
                context.buttonTitle = R.string.localizable.confirm.key.localized()
                context.imageName = R.image.icFail.name
                context.needCancel = false
                appCoodinator.showGemmaAlert(context)
                if let currencyid = currencyID {
                    CurrencyManager.shared.saveActived(currencyid, actived: .nonActived)
                }
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

    func switchPageState(_ state: PageState) {
        DispatchQueue.main.async {
            self.store.dispatch(PageStateAction(state: state))
        }
    }
}
