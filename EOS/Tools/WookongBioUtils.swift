//
//  BLTUtils.swift
//  EOS
//
//  Created by peng zhu on 2018/10/16.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation
import Presentr
import SwiftyUserDefaults

func connectBLTCard(_ rootVC: UINavigationController, complication: @escaping CompletionCallback) {
    let width = ModalSize.full
    let height = ModalSize.custom(size: 180)
    let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: 0, y: UIScreen.main.bounds.height - 180))
    let customType = PresentationType.custom(width: width, height: height, center: center)

    let presenter = Presentr(presentationType: customType)
    presenter.dismissOnTap = false
    presenter.keyboardTranslationType = .stickToTop

    var context = BLTCardConnectContext()
    context.connectSuccessed = {()
        complication()
    }

    if let connectVC = R.storyboard.bltCard.bltCardConnectViewController() {
        let nav = BaseNavigationController.init(rootViewController: connectVC)
        let coordinator = BLTCardConnectCoordinator(rootVC: nav)
        connectVC.coordinator = coordinator
        coordinator.store.dispatch(RouteContextAction(context: context))
        rootVC.customPresentViewController(presenter, viewController: nav, animated: true)
    }
}

func confirmPin(_ rootVC: UINavigationController, complication: @escaping SuccessedComplication) {
    let width = ModalSize.full

    let height: Float = 249.0
    let centerHeight = UIScreen.main.bounds.height - height.cgFloat
    let heightSize = ModalSize.custom(size: height)

    let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: 0, y: centerHeight))
    let customType = PresentationType.custom(width: width, height: heightSize, center: center)

    let presenter = Presentr(presentationType: customType)
    presenter.keyboardTranslationType = .stickToTop
    presenter.dismissOnTap = false

    var context = BLTCardConfirmPinContext()
    context.confirmSuccessed = {()
        complication()
    }

    if let pinVC = R.storyboard.bltCard.bltCardConfirmPinViewController() {
        let nav = BaseNavigationController.init(rootViewController: pinVC)
        let coordinator = BLTCardConfirmPinCoordinator(rootVC: nav)
        pinVC.coordinator = coordinator
        coordinator.store.dispatch(RouteContextAction(context: context))
        rootVC.customPresentViewController(presenter, viewController: nav, animated: true)
    }
}

func confirmFP(_ rootVC: UINavigationController, complication: @escaping SuccessedComplication) {
    let width = ModalSize.full

    let height: Float = 338.0
    let centerHeight = UIScreen.main.bounds.height - height.cgFloat
    let heightSize = ModalSize.custom(size: height)

    let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: 0, y: centerHeight))
    let customType = PresentationType.custom(width: width, height: heightSize, center: center)

    let presenter = Presentr(presentationType: customType)
    presenter.keyboardTranslationType = .stickToTop
    presenter.dismissOnTap = false

    var context = BLTCardConfirmFingerPrinterContext()
    context.confirmSuccessed = {()
        complication()
    }

    if let fpVC = R.storyboard.bltCard.bltCardConfirmFingerPrinterViewController() {
        let nav = BaseNavigationController.init(rootViewController: fpVC)
        let coordinator = BLTCardConfirmFingerPrinterCoordinator(rootVC: nav)
        fpVC.coordinator = coordinator
        coordinator.store.dispatch(RouteContextAction(context: context))
        rootVC.customPresentViewController(presenter, viewController: nav, animated: true)
    }
}

func presentFingerPrinterSetVC() {
    
}

func selectBLTInitType(_ rootVC: UINavigationController, isCreateCallBack: @escaping ResultCallback) {
    let width = ModalSize.full

    let height: Float = 249.0
    let centerHeight = UIScreen.main.bounds.height - height.cgFloat
    let heightSize = ModalSize.custom(size: height)

    let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: 0, y: centerHeight))
    let customType = PresentationType.custom(width: width, height: heightSize, center: center)

    let presenter = Presentr(presentationType: customType)
    presenter.keyboardTranslationType = .stickToTop

    var context = BLTInitTypeSelectContext()
    context.isCreateCallback = { (isCreate) in
        isCreateCallBack(isCreate)
    }

    if let initVC = R.storyboard.bltCard.bltInitTypeSelectViewController() {
        let nav = BaseNavigationController.init(rootViewController: initVC)
        let coordinator = BLTInitTypeSelectCoordinator(rootVC: nav)
        initVC.coordinator = coordinator
        coordinator.store.dispatch(RouteContextAction(context: context))
        rootVC.customPresentViewController(presenter, viewController: nav, animated: true)
    }
}

func importWookongBioWallet(_ hint: String,
                            success: @escaping SuccessedComplication,
                            failed: @escaping FailedComplication) {
    do {
        let date = Date.init()
        let wallet = Wallet(id: nil, name: WalletManager.shared.bltWalletName(), type: .bluetooth, cipher: "", deviceName: BLTWalletIO.shareInstance()?.selectDevice.name, date: date, hint: hint)
        if let walletId =  try WalletCacheService.shared.insertWallet(wallet: wallet) {
            BLTWalletIO.shareInstance()?.getPubKey({ (pubkey, pubkeySign) in
                let currency = Currency(id: nil, type: .EOS, cipher: "", pubKey: pubkey, wid: walletId, date: date, address: nil)
                saveCurrency(currency)
                Defaults[.currentWalletID] = walletId.string
                success()
                }, failed: failed)
        }
    } catch {
        failed(R.string.localizable.prompt_create_failed.key.localized())
    }
}

func saveCurrency(_ currency: Currency) {
    do {
        let  currencyId = try WalletCacheService.shared.insertCurrency(currency)
        CurrencyManager.shared.getEOSAccountNames(currency.pubKey ?? "", completion: { (result, accounts) in
            if result {
                CurrencyManager.shared.saveAccountNamesWith(currencyId, accounts: accounts)
                CurrencyManager.shared.saveActived(currencyId, actived: true)
                if accounts.count > 0 {
                    CurrencyManager.shared.saveAccountNameWith(currencyId, name: accounts[0])
                }
            }
        })
    } catch {}
}

func imageWithInfo(_ info: BLTBatteryInfo?) -> UIImage {
    guard let info = info else {
        return R.image.ic_wookong_bio_unconnected()!
    }
    if info.state == charge {
        return R.image.ic_charge()!
    }
    return R.image.ic_wookong_bio_connected()!
}

func desWithInfo(_ info: BLTBatteryInfo?) -> String {
    guard let info = info else {
        return R.string.localizable.wookong_connect_none.key.localized()
    }
    if info.state == charge {
        return R.string.localizable.wookong_connect_successed.key.localized()
    }

    if info.electricQuantity == 0 {
        return R.string.localizable.wookong_connect_successed.key.localized()
    }
    let formatter = NumberFormatter()
    formatter.numberStyle = .percent
    formatter.percentSymbol = ""
    return R.string.localizable.battery.key.localized() + formatter.string(from: NSNumber(value:info.electricQuantity))! + "%"
}

func batteryNumberInfo(_ info: BLTBatteryInfo?) -> String {
    guard let info = info else {
        return "0%"
    }
    let formatter = NumberFormatter()
    formatter.numberStyle = .percent
    formatter.percentSymbol = ""
    return formatter.string(from: NSNumber(value:info.electricQuantity))! + "%"
}
