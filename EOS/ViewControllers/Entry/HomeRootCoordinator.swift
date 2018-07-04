//
//  HomeRootCoordinator.swift
//  EOS
//
//  Created by koofrank on 2018/7/4.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation

class HomeRootCoordinator: NavCoordinator {
    override func start() {
        if let vc = R.storyboard.home.homeViewController() {
            let coordinator = HomeCoordinator(rootVC: self.rootVC)
            vc.coordinator = coordinator
            self.rootVC.pushViewController(vc, animated: true)
        }
    }
}
