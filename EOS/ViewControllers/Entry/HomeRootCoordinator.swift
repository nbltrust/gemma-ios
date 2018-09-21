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
        self.rootVC.pushViewController(HomeCoordinator.start(self.rootVC), animated: true)
    }
}
