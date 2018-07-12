//
//  AppCoordinator.swift
//  EOS
//
//  Created by koofrank on 2018/7/4.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import ReSwift
import ESTabBarController_swift
import SwifterSwift

class AppCoordinator {
    var store = Store<AppState> (
        reducer: AppReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
    
    var state: AppState {
        return store.state
    }
    
    var rootVC: BaseTabbarViewController
    
    var homeCoordinator: HomeRootCoordinator!
    var transferCoordinator: TransferRootCoordinator!
    var userinfoCoordinator: UserInfoRootCoordinator!

    var entryCoordinator: EntryRootCoordinator!
    var transferCoordinator: TransferRootCoordinator!

    weak var currentPresentedRootCoordinator: NavCoordinator?
    
    weak var startLoadingVC:BaseViewController?
    
    init(rootVC: BaseTabbarViewController) {
        self.rootVC = rootVC
    }
    
    func start() {
        if let tabBar = rootVC.tabBar as? ESTabBar {
//            tabBar.barTintColor = UIColor.dark
            tabBar.backgroundImage = UIImage()
        }
        
        let home = BaseNavigationController()
        homeCoordinator = HomeRootCoordinator(rootVC: home)
        home.tabBarItem = ESTabBarItem.init(CBTabBarView(), title: R.string.localizable.tabbarWallet(), image: R.image.ic_wallet_normal(), selectedImage: R.image.ic_wallet_selected())
        //        home.tabBarItem.badgeValue = ""
        
        let transfer = BaseNavigationController()
        transferCoordinator = TransferRootCoordinator(rootVC: transfer)
        transfer.tabBarItem = ESTabBarItem.init(CBTabBarView(), title: R.string.localizable.tabbarTransfer(), image: R.image.ic_send_normal(), selectedImage: R.image.ic_send_selected())
        
        let userinfo = BaseNavigationController()
        userinfoCoordinator = UserInfoRootCoordinator(rootVC: userinfo)
        userinfo.tabBarItem = ESTabBarItem.init(CBTabBarView(), title: R.string.localizable.tabbarMine(), image: R.image.ic_me_normal(), selectedImage: R.image.ic_me_normal())
        
        homeCoordinator.start()
        transferCoordinator.start()
        userinfoCoordinator.start()

        rootVC.viewControllers = [home, transfer, userinfo]
    }
    
    func showEntry() {
        let nav = BaseNavigationController()
        entryCoordinator = EntryRootCoordinator(rootVC: nav)
        entryCoordinator.start()
        
        SwifterSwift.delay(milliseconds: 100) {
            self.rootVC.present(nav, animated: true, completion: nil)
        }
        
    }

    func showTest() {
//        let nav = BaseNavigationController()
//        let vc = R.storyboard.payments.paymentsViewController()!
//        let coor = PaymentsCoordinator(rootVC: nav)
//        vc.coordinator = coor
//        
//        SwifterSwift.delay(milliseconds: 100) {
//            self.rootVC.present(vc, animated: true, completion: nil)
//        }

        let nav = BaseNavigationController()
        transferCoordinator = TransferRootCoordinator(rootVC: nav)
        transferCoordinator.start()
        
        SwifterSwift.delay(milliseconds: 100) {
            self.rootVC.present(nav, animated: true, completion: nil)
        }
        
    }
    
    
}
