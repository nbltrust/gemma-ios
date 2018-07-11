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
    var entryCoordinator: EntryRootCoordinator!

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
//        home.tabBarItem = ESTabBarItem.init(CBTabBarView(), title: R.string.localizable.navWatchlist.key.localized(), image: R.image.ic_watchlist_24px(), selectedImage: R.image.ic_watchlist_active_24px())
        
        
        
        
        //        home.tabBarItem.badgeValue = ""
        //        message.tabBarItem.badgeValue = "99+"
        
        homeCoordinator.start()
     
        rootVC.viewControllers = [home]
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
        let nav = BaseNavigationController()
        let vc = R.storyboard.transfer.transferViewController()!
        let coor = TransferCoordinator(rootVC: nav)
        vc.coordinator = coor
//        root.start()
        
        SwifterSwift.delay(milliseconds: 100) {
            self.rootVC.present(vc, animated: true, completion: nil)
        }

    }
    
}
