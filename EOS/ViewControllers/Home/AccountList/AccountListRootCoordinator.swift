//
//  AccountListRootCoordinator.swift
//  EOS
//
//  Created by zhusongyu on 2018/7/23.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation

class AccountListRootCoordinator: NavCoordinator {
    override func start() {
        if let vc = R.storyboard.accountList.accountListViewController() {
            let coordinator = AccountListCoordinator(rootVC: self.rootVC)
            vc.coordinator = coordinator
            self.rootVC.pushViewController(vc, animated: true)
        }
    }
}
