//
//  BLTUtils.swift
//  EOS
//
//  Created by peng zhu on 2018/10/16.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation
import Presentr

func connectBLTCard(_ complication: @escaping CompletionCallback) {
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

    if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
        if let connectVC = R.storyboard.bltCard.bltCardConnectViewController() {
            let nav = BaseNavigationController.init(rootViewController: connectVC)
            let coordinator = BLTCardConnectCoordinator(rootVC: nav)
            connectVC.coordinator = coordinator
            coordinator.store.dispatch(RouteContextAction(context: context))
            rootVC.customPresentViewController(presenter, viewController: nav, animated: true)
        }
    }
}

func confirmPin(_ complication: @escaping SuccessedComplication) {
    let width = ModalSize.full

    let height: Float = 249.0
    let centerHeight = UIScreen.main.bounds.height - height.cgFloat
    let heightSize = ModalSize.custom(size: height)

    let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: 0, y: centerHeight))
    let customType = PresentationType.custom(width: width, height: heightSize, center: center)

    let presenter = Presentr(presentationType: customType)
    presenter.keyboardTranslationType = .stickToTop

    var context = BLTCardConfirmPinContext()
    context.confirmSuccessed = {()
        complication()
    }

    if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
        if let connectVC = R.storyboard.bltCard.bltCardConfirmPinViewController() {
            let nav = BaseNavigationController.init(rootViewController: connectVC)
            let coordinator = BLTCardConfirmPinCoordinator(rootVC: nav)
            connectVC.coordinator = coordinator
            coordinator.store.dispatch(RouteContextAction(context: context))
            rootVC.customPresentViewController(presenter, viewController: nav, animated: true)
        }
    }
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
    let formatter = NumberFormatter()
    formatter.numberStyle = .percent
    formatter.percentSymbol = ""
    return R.string.localizable.battery.key.localized() + formatter.string(from: NSNumber(value:info.electricQuantity))!
}
