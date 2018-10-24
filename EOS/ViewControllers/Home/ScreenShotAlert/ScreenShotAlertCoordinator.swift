//
//  ScreenShotAlertCoordinator.swift
//  EOS
//
//  Created zhusongyu on 2018/8/2.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

protocol ScreenShotAlertCoordinatorProtocol {
    func dismissVC()
}

protocol ScreenShotAlertStateManagerProtocol {
    var state: ScreenShotAlertState { get }
}

class ScreenShotAlertCoordinator: NavCoordinator {

    var store = Store<ScreenShotAlertState>(
        reducer: ScreenShotAlertReducer,
        state: nil,
        middleware: [TrackingMiddleware]
    )

    override class func start(_ root: BaseNavigationController, context: RouteContext? = nil) -> BaseViewController {
        let vc = R.storyboard.screenShotAlert.screenShotAlertViewController()!
        let coordinator = ScreenShotAlertCoordinator(rootVC: root)
        vc.coordinator = coordinator
        coordinator.store.dispatch(RouteContextAction(context: context))
        return vc
    }

}

extension ScreenShotAlertCoordinator: ScreenShotAlertCoordinatorProtocol {
    func dismissVC() {
        dismiss()
    }
}

extension ScreenShotAlertCoordinator: ScreenShotAlertStateManagerProtocol {
    var state: ScreenShotAlertState {
        return store.state
    }

    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<ScreenShotAlertState>) -> Subscription<SelectedState>)?
        ) where S.StoreSubscriberStateType == SelectedState {
        store.subscribe(subscriber, transform: transform)
    }

}
