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
import Presentr

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

    var entryCoordinator: EntryRootCoordinator?

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
        userinfo.tabBarItem = ESTabBarItem.init(CBTabBarView(), title: R.string.localizable.tabbarMine(), image: R.image.ic_me_normal(), selectedImage: R.image.ic_me_selected())
        
        homeCoordinator.start()
        transferCoordinator.start()
        userinfoCoordinator.start()

        rootVC.viewControllers = [home, transfer, userinfo]
    }
    
    func curDisplayingCoordinator() -> NavCoordinator {
        let container = [homeCoordinator, transferCoordinator, userinfoCoordinator] as [NavCoordinator]
        return container[self.rootVC.selectedIndex]
    }
    
    func showEntry() {
        let nav = BaseNavigationController()
        entryCoordinator = EntryRootCoordinator(rootVC: nav)
        entryCoordinator?.start()
        
        SwifterSwift.delay(milliseconds: 100) {
            self.rootVC.present(nav, animated: true, completion: nil)
        }
        
    }
    
    func endEntry() {
        entryCoordinator?.rootVC.dismiss(animated: true) { [weak self] in
            self?.entryCoordinator = nil
        }
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
    
    func showPresenterPwd(leftIconType: leftIconType, pubKey:String = WalletManager.shared.currentPubKey, completion: StringCallback? = nil) {
        let width = ModalSize.full
        let height = ModalSize.custom(size: 271)
        let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: 0, y: UIScreen.main.bounds.height - 271))
        let customType = PresentationType.custom(width: width, height: height, center: center)
        
        let presenter = Presentr(presentationType: customType)
        presenter.keyboardTranslationType = .moveUp
        
        let newVC = BaseNavigationController()
        newVC.navStyle = .white
        let transferConfirmpwd = TransferConfirmPasswordRootCoordinator(rootVC: newVC)
            
        if let entryCoor = entryCoordinator {
            entryCoor.rootVC.topViewController?.customPresentViewController(presenter, viewController: newVC, animated: true, completion: nil)
        }
        else {
            curDisplayingCoordinator().rootVC.customPresentViewController(presenter, viewController: newVC, animated: true, completion: nil)
        }
        if let vc = R.storyboard.transfer.transferConfirmPasswordViewController() {
            let coordinator = TransferConfirmPasswordCoordinator(rootVC: transferConfirmpwd.rootVC)
            vc.coordinator = coordinator
            vc.publicKey = pubKey
            vc.iconType = leftIconType.rawValue
            vc.callback = {[weak vc] priKey in
                vc?.dismiss(animated: true, completion: {
                    completion?(priKey)
                })
            }
            transferConfirmpwd.rootVC.pushViewController(vc, animated: true)
        }
    }
    
}
