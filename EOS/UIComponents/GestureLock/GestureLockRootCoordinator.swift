//
//  GestureLockRootCoordinator.swift
//  EOS
//
//  Created by peng zhu on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit

enum GestureLockMode: Int {
    case set = 1
    case comfirm
    case update
}

class GestureLockRootCoordinator: NavCoordinator {
    var lockMode: GestureLockMode = .set
    
    override func start() {
        if lockMode == .set {
            showSetVC()
        } else {
            shomComfirmVC()
        }
    }
    
    func showSetVC() {
        if let vc = R.storyboard.gestureLock.gestureLockSetViewController() {
            let coordinator = GestureLockSetCoordinator(rootVC: self.rootVC)
            vc.coordinator = coordinator
            self.rootVC.pushViewController(vc, animated: true)
        }
    }
    
    func shomComfirmVC() {
        if let vc = R.storyboard.gestureLock.gestureLockComfirmViewController() {
            let coordinator = GestureLockComfirmCoordinator(rootVC: self.rootVC)
            vc.coordinator = coordinator
            self.rootVC.pushViewController(vc, animated: true)
        }
    }
}
