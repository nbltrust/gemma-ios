//
//  NavCoordinator.swift
//  EOS
//
//  Created by koofrank on 2018/7/4.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import NBLCommonModule
import SwifterSwift

protocol NavProtocol {
    func openWebVC(url:URL)
    func pushVC<T:NavCoordinator>(_ coordinator: T.Type, animated:Bool, setup: ((BaseViewController) -> Void)?)
    func presentVC<T:NavCoordinator>(_ coordinator: T.Type, animated:Bool, setup: ((BaseViewController) -> Void)?, navSetup: ((BaseNavigationController) -> Void)?, presentSetup:((_ top:BaseNavigationController, _ target:BaseNavigationController) -> Void)?)
    
    func register()
}

class NavCoordinator:NavProtocol {
    
    weak var rootVC: BaseNavigationController!
    
    init(rootVC: BaseNavigationController) {
        self.rootVC = rootVC
        register()
    }
    
    class func start(_ root: BaseNavigationController) -> BaseViewController {
        return BaseViewController()
    }
}

extension NavCoordinator {
    func openWebVC(url:URL) {
        let web = BaseWebViewController()
        web.url = url
        
        self.rootVC.pushViewController(web, animated: true)
    }

    func pushVC<T:NavCoordinator>(_ coordinator: T.Type, animated:Bool = true, setup: ((BaseViewController) -> Void)?) {
        let vc = coordinator.start(self.rootVC)
        setup?(vc)
        self.rootVC.pushViewController(vc, animated: animated)
    }
    
    func presentVC<T:NavCoordinator>(_ coordinator: T.Type, animated:Bool = true,
                                     setup: ((BaseViewController) -> Void)?,
                                     navSetup: ((BaseNavigationController) -> Void)?,
                                     presentSetup:((_ top:BaseNavigationController, _ target:BaseNavigationController) -> Void)?) {
        let nav = BaseNavigationController()
        navSetup?(nav)
        let coor = NavCoordinator(rootVC: nav)
        coor.pushVC(coordinator, animated: false, setup: setup)
        
        var topside = self.rootVC!
        
        while topside.presentedViewController != nil  {
            topside = topside.presentedViewController as! BaseNavigationController
        }
        
        if presentSetup == nil {
            SwifterSwift.delay(milliseconds: 100) {
                topside.present(nav, animated: animated, completion: nil)
            }
        }
        else {
            presentSetup?(topside, nav)
        }
  
    }
    
    @objc func register() {
        
    }

}
