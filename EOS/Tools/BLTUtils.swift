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
    
    if let vc = UIApplication.shared.keyWindow?.rootViewController {
        if let connectVC = R.storyboard.bltCard.bltCardConnectViewController() {
            let nav = BaseNavigationController.init(rootViewController: connectVC)
            nav.navStyle = .white
            let coordinator = BLTCardConnectCoordinator(rootVC:nav)
            connectVC.coordinator = coordinator
            coordinator.store.dispatch(RouteContextAction(context: context))
            vc.customPresentViewController(presenter, viewController: nav, animated: true)
        }
    }
}
