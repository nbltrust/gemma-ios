//
//  TransferRootCoordinator.swift
//  EOS
//
//  Created by 朱宋宇 on 2018/7/10.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
class TransferRootCoordinator: NavCoordinator {
    override func start() {
        if let vc = R.storyboard.transfer.transferViewController() {
            let coordinator = TransferCoordinator(rootVC: self.rootVC)
            vc.coordinator = coordinator
            self.rootVC.pushViewController(vc, animated: true)
        }
    }
}
