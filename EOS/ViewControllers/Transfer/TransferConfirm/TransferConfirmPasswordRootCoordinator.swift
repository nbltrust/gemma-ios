//
//  TransferConfirmPasswordRootCoordinator.swift
//  EOS
//
//  Created by zhusongyu on 2018/7/23.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation

class TransferConfirmPasswordRootCoordinator: NavCoordinator {
    override func start() {
        if let vc = R.storyboard.transfer.transferConfirmPasswordViewController() {
            let coordinator = TransferConfirmPasswordCoordinator(rootVC: self.rootVC)
            vc.coordinator = coordinator
            self.rootVC.pushViewController(vc, animated: true)
        }
    }
}
