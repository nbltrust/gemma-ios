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

    var rootVC: BaseTabbarViewController

    var newHomeCoordinator: NavCoordinator!
    var homeCoordinator: NavCoordinator!
    var transferCoordinator: NavCoordinator!
    var userinfoCoordinator: NavCoordinator!
    var homeItem: ESTabBarItem!
    var transferItem: ESTabBarItem!
    var userInfoItem: ESTabBarItem!
    var newHomeItem: ESTabBarItem!

    var entryCoordinator: NavCoordinator?

    weak var currentPresentedRootCoordinator: NavCoordinator?

    weak var startLoadingVC: BaseViewController?

    init(rootVC: BaseTabbarViewController) {
        self.rootVC = rootVC

        rootVC.shouldHijackHandler = {[weak self] (tab, vc, index) in
            guard let `self` = self else { return false }
            if self.rootVC.selectedIndex == index, let nav = vc as? BaseNavigationController {
                nav.topViewController?.refreshViewController()
            }

            return false
        }

    }

    func start() {
        if let tabBar = rootVC.tabBar as? ESTabBar {
//            tabBar.barTintColor = UIColor.dark
            tabBar.backgroundImage = UIImage()
        }

//        let newhome = BaseNavigationController()
//        newHomeCoordinator = NavCoordinator(rootVC: newhome)
//
//        newHomeItem = ESTabBarItem.init(CBTabBarView(), title: R.string.localizable.tabbarWallet.key.localized(), image: R.image.ic_wallet_normal(), selectedImage: R.image.ic_wallet_selected())
//        newhome.tabBarItem = homeItem

        let home = BaseNavigationController()
        homeCoordinator = NavCoordinator(rootVC: home)

        homeItem = ESTabBarItem.init(CBTabBarView(), title: R.string.localizable.tabbarWallet.key.localized(), image: R.image.ic_wallet_normal(), selectedImage: R.image.ic_wallet_selected())
        home.tabBarItem = homeItem

        let transfer = BaseNavigationController()
        transferCoordinator = NavCoordinator(rootVC: transfer)
        transferItem = ESTabBarItem.init(CBTabBarView(), title: R.string.localizable.tabbarTransfer.key.localized(), image: R.image.ic_send_normal(), selectedImage: R.image.ic_send_selected())
        transfer.tabBarItem = transferItem

        let userinfo = BaseNavigationController()
        userinfoCoordinator = NavCoordinator(rootVC: userinfo)
        userInfoItem = ESTabBarItem.init(CBTabBarView(), title: R.string.localizable.tabbarMine.key.localized(), image: R.image.ic_me_normal(), selectedImage: R.image.ic_me_selected())
        userinfo.tabBarItem = userInfoItem

//        newHomeCoordinator.pushVC(NewHomeCoordinator.self, animated: true, context: nil)
        homeCoordinator.pushVC(HomeCoordinator.self, animated: true, context: nil)
        transferCoordinator.pushVC(TransferCoordinator.self, animated: true, context: nil)
        userinfoCoordinator.pushVC(UserInfoCoordinator.self, animated: true, context: nil)

        rootVC.viewControllers = [home, transfer, userinfo]
        aspect()
    }

    func updateTabbar() {
        homeItem.title = R.string.localizable.tabbarWallet.key.localized()
        transferItem.title = R.string.localizable.tabbarTransfer.key.localized()
        userInfoItem.title = R.string.localizable.tabbarMine.key.localized()
    }

    func aspect() {
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: nil) {[weak self] (_) in
            guard let `self` = self else { return }
            self.curDisplayingCoordinator().rootVC.topViewController?.refreshViewController()
        }

        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: LCLLanguageChangeNotification), object: nil, queue: nil) {[weak self] (_) in
            guard let `self` = self else { return }
            self.updateTabbar()
        }
    }

    func curDisplayingCoordinator() -> NavCoordinator {
        let container = [homeCoordinator, transferCoordinator, userinfoCoordinator] as [NavCoordinator]
        return container[self.rootVC.selectedIndex]
    }

    func showEntry() {
        presentVC(EntryGuideCoordinator.self, animated: true, context: nil, navSetup: nil, presentSetup: nil)
    }

    func endEntry() {
        curDisplayingCoordinator().rootVC.dismiss(animated: true, completion: nil)
    }

    func showTest() {
        let nav = BaseNavigationController()
        let vc = R.storyboard.entry.creatationCompleteViewController()!
        let coor = CreatationCompleteCoordinator(rootVC: nav)
        vc.coordinator = coor

        SwifterSwift.delay(milliseconds: 100) {
            self.rootVC.present(vc, animated: true, completion: nil)
        }

    }

    func showPresenterPwd(leftIconType: leftIconType, pubKey: String = WalletManager.shared.currentPubKey, type: String, producers: [String], completion: StringCallback? = nil) {
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
        context.publicKey = pubKey
        context.iconType = leftIconType.rawValue
        context.type = type
        context.producers = producers
        context.callback = { (priKey, vc) in
            vc.dismiss(animated: true, completion: {
                completion?(priKey)
            })
        }
        presentVC(TransferConfirmPasswordCoordinator.self, animated: true, context: context, navSetup: { (nav) in
            nav.navStyle = .white

        }) { (top, target) in
            top.customPresentViewController(presenter, viewController: target, animated: true, completion: nil)
        }
    }
    func showGemmaAlert(_ context: ScreenShotAlertContext? = nil) {
        let presenter = Presentr(presentationType: PresentationType.fullScreen)
        presenter.keyboardTranslationType = .stickToTop

        presentVCNoNav(ScreenShotAlertCoordinator.self, context: context) { (top, target) in
            top.customPresentViewController(presenter, viewController: target, animated: true)
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
