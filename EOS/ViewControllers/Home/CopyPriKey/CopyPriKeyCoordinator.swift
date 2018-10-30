//
//  CopyPriKeyCoordinator.swift
//  EOS
//
//  Created peng zhu on 2018/8/1.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift
import Presentr
import eos_ios_core_cpp

protocol CopyPriKeyCoordinatorProtocol {
    func showAlertMessage()
    func pushVerifyPriKey()
}

protocol CopyPriKeyStateManagerProtocol {
    var state: CopyPriKeyState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<CopyPriKeyState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState
}

class CopyPriKeyCoordinator: NavCoordinator {

    lazy var creator = CopyPriKeyPropertyActionCreate()

    var store = Store<CopyPriKeyState>(
        reducer: gCopyPriKeyReducer,
        state: nil,
        middleware: [trackingMiddleware]
    )
}

extension CopyPriKeyCoordinator: CopyPriKeyCoordinatorProtocol {
    func showAlertMessage() {
        var context = ScreenShotAlertContext()
        context.desc = RichStyle.shared.tagText(R.string.localizable.backup_introduce_three.key.localized(), fontSize: 14, color: UIColor.blueyGrey, lineHeight: 20)
        context.title = R.string.localizable.dont_screen_shot.key.localized()
        context.buttonTitle = R.string.localizable.i_know.key.localized()
        context.imageName = R.image.icPopNoScreenshots.name
        context.needCancel = false
        appCoodinator.showGemmaAlert(context)
    }

    func pushVerifyPriKey() {
        pushVC(VerifyPriKeyCoordinator.self, animated: true, context: nil)
    }
}

extension CopyPriKeyCoordinator: CopyPriKeyStateManagerProtocol {
    var state: CopyPriKeyState {
        return store.state
    }

    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<CopyPriKeyState>) -> Subscription<SelectedState>)?
        ) where S.StoreSubscriberStateType == SelectedState {
        store.subscribe(subscriber, transform: transform)
    }

}
