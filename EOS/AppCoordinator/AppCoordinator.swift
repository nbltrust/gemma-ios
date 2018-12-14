//
//  AppCoordinator.swift
//  EOS
//
//  Created by koofrank on 2018/7/4.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import ReSwift
import ESTabBarController
import SwifterSwift
import Presentr
import Localize_Swift

class AppCoordinator {
    var store = Store<AppState> (
        reducer: gAppReducer,
        state: nil,
        middleware: [trackingMiddleware]
    )

    var state: AppState {
        return store.state
    }

    var rootVC: BaseNavigationController

    var newHomeCoordinator: NavCoordinator!

    var entryCoordinator: NavCoordinator?

    weak var currentPresentedRootCoordinator: NavCoordinator?

    weak var startLoadingVC: BaseViewController?

    init(rootVC: BaseNavigationController) {
        self.rootVC = rootVC
    }

    func start() {
        let newVC = R.storyboard.home.newHomeViewController()!
        newHomeCoordinator = NewHomeCoordinator(rootVC: self.rootVC)
        let coor = NewHomeCoordinator(rootVC: self.rootVC)
        newVC.coordinator = coor
        self.rootVC.pushViewController(newVC, animated: false)
        aspect()
    }

    func aspect() {
    }

    func curDisplayingCoordinator() -> NavCoordinator {
        let container = newHomeCoordinator as NavCoordinator

        return container
    }

    func showEntry() {
        presentVC(EntryGuideCoordinator.self, animated: false, context: nil, navSetup: nil, presentSetup: nil)
    }

    func endEntry() {
        curDisplayingCoordinator().rootVC.dismiss(animated: true, completion: nil)
    }

    func showPresenterPwd(leftIconType: LeftIconType, currencyID: Int64?, type: String, producers: [String], completion: StringCallback? = nil) {
        let width = ModalSize.full

        var height: Float = 271.0
        if type == ConfirmType.updatePwd.rawValue {
            height = 249.0
        }
        let heightSize = ModalSize.custom(size: height)

        let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: 0, y: UIScreen.main.bounds.height - height.cgFloat))
        let customType = PresentationType.custom(width: width, height: heightSize, center: center)

        let presenter = Presentr(presentationType: customType)
        presenter.keyboardTranslationType = .stickToTop

        var context = TransferConfirmPasswordContext()
        context.currencyID = currencyID
        context.iconType = leftIconType.rawValue
        context.type = type
        context.producers = producers
        context.callback = { (priKey, vc) in
            vc.dismiss(animated: true, completion: {
                completion?(priKey)
            })
        }
        presentVC(TransferConfirmPasswordCoordinator.self, animated: true, context: context, navSetup: { (nav) in
            nav.navStyle = .common
        }) { (top, target) in
            top.customPresentViewController(presenter, viewController: target, animated: true, completion: nil)
        }
    }

    func showGemmaAlert(_ context: ScreenShotAlertContext? = nil) {
        let presenter = Presentr(presentationType: PresentationType.fullScreen)
        presenter.keyboardTranslationType = .stickToTop
        presentVCNoNav(ScreenShotAlertCoordinator.self, context: context) { (top, target) in
            top.customPresentViewController(presenter, viewController: target, animated: false)
        }
    }
}

extension AppCoordinator {
    func pushVC<T: NavCoordinator>(_ coordinator: T.Type, animated: Bool = true, context: RouteContext? = nil) {
        let topside = curDisplayingCoordinator().rootVC!
        let vc = coordinator.start(topside, context: context)
        topside.pushViewController(vc, animated: animated)
    }

    func presentVC<T: NavCoordinator>(_ coordinator: T.Type, animated: Bool = true, context: RouteContext? = nil,
                                     navSetup: ((BaseNavigationController) -> Void)?,
                                     presentSetup:((_ top: BaseNavigationController, _ target: BaseNavigationController) -> Void)?) {
        let nav = BaseNavigationController()
        navSetup?(nav)
        let coor = NavCoordinator(rootVC: nav)
        coor.pushVC(coordinator, animated: false, context: context)

        var topside = curDisplayingCoordinator().rootVC

        while topside?.presentedViewController != nil {
            topside = topside?.presentedViewController as? BaseNavigationController
        }

        if presentSetup == nil {
            SwifterSwift.delay(milliseconds: 100) {
                topside?.present(nav, animated: animated, completion: nil)
            }
        } else if let top = topside {
            presentSetup?(top, nav)
        }
    }

    func presentVCNoNav<T: NavCoordinator>(_ coordinator: T.Type,
                                           animated: Bool = true,
                                           context: RouteContext? = nil,
                                           presentSetup:((_ top: BaseNavigationController,
        _ target: BaseViewController) -> Void)?) {
        guard var topside = curDisplayingCoordinator().rootVC else {
            return
        }

        let viewController = coordinator.start(topside, context: context)

        while topside.presentedViewController != nil {
            if let presented = topside.presentedViewController as? BaseNavigationController {
                topside = presented
            }
        }

        if presentSetup == nil {
            SwifterSwift.delay(milliseconds: 100) {
                topside.present(viewController, animated: animated, completion: nil)
            }
        } else {
            presentSetup?(topside, viewController)
        }
    }
}
