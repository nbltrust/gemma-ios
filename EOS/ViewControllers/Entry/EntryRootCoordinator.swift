//
//  EntryRootCoordinator.swift
//  EOS
//
//  Created by koofrank on 2018/7/4.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation

class EntryRootCoordinator: NavCoordinator {
    override func start() {
        if let vc = R.storyboard.entry.entryViewController() {
            let coordinator = EntryCoordinator(rootVC: self.rootVC)
            vc.coordinator = coordinator
            self.rootVC.pushViewController(vc, animated: true)
        }
    }
}
