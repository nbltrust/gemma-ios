//
//  ScreenShotAlertRootCoordinator.swift
//  EOS
//
//  Created by zhusongyu on 2018/7/20.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
class ScreenShotAlertRootCoordinator: NavCoordinator {
    override func start() {
        if let vc = R.storyboard.screenShotAlert.screenShotAlertViewController() {
            let coordinator = ScreenShotAlertCoordinator(rootVC: self.rootVC)
            vc.coordinator = coordinator
            self.rootVC.pushViewController(vc, animated: true)
        }
    }
}
