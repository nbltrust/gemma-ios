//
//  UserInfoRootCoordinator.swift
//  EOS
//
//  Created by koofrank on 2018/7/12.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation

class UserInfoRootCoordinator:NavCoordinator {
    override func start() {
        if let vc = R.storyboard.userInfo.userInfoViewController() {
            let coordinator = UserInfoCoordinator(rootVC: self.rootVC)
            vc.coordinator = coordinator
            self.rootVC.pushViewController(vc, animated: true)
        }
    }
}
