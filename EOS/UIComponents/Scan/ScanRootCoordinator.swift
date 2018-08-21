//
//  ScanRootCoordinator.swift
//  EOS
//
//  Created by peng zhu on 2018/7/18.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit

class ScanRootCoordinator: NavCoordinator {
    override func start() {
        let vc = ScanViewController()
        vc.subTitle = R.string.localizable.scan_subTitle.key.localized()
        let coordinator = ScanCoordinator(rootVC: self.rootVC)
        vc.coordinator = coordinator
        self.rootVC.pushViewController(vc, animated: true)
    }
}
