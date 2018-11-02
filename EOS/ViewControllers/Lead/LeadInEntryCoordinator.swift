//
//  LeadInEntryCoordinator.swift
//  EOS
//
//  Created peng zhu on 2018/10/30.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift
import NBLCommonModule

protocol LeadInEntryCoordinatorProtocol {
    func pushToScanVC()
}

protocol LeadInEntryStateManagerProtocol {
    var state: LeadInEntryState { get }
    
    func switchPageState(_ state:PageState)

    func viewControllers() -> [UIViewController]
}

class LeadInEntryCoordinator: NavCoordinator {
    var store = Store(
        reducer: gLeadInEntryReducer,
        state: nil,
        middleware:[trackingMiddleware]
    )

    var state: LeadInEntryState {
        return store.state
    }

    override func register() {
        Broadcaster.register(LeadInEntryCoordinatorProtocol.self, observer: self)
        Broadcaster.register(LeadInEntryStateManagerProtocol.self, observer: self)
    }
}

extension LeadInEntryCoordinator: LeadInEntryCoordinatorProtocol {
    func pushToScanVC() {
        let context = ScanContext()
        context.scanResult.accept { (result) in
            if let entryVC = self.rootVC.topViewController as? LeadInEntryViewController {
                switch entryVC.currentIndex {
                case 0:
                    if let mnemonicVC = entryVC.viewControllers[0] as? LeadInMnemonicViewController {
                        mnemonicVC.mnemonicView.textView.text = result
                    }
                case 1:
                    if let priKeyVC = entryVC.viewControllers[1] as? LeadInKeyViewController {
                        priKeyVC.leadInKeyView.textView.text = result
                    }
                default:
                    return
                }
            }
        }

        presentVC(ScanCoordinator.self, context: context, navSetup: { (nav) in
            nav.navStyle = .clear
        }, presentSetup: nil)
    }
}

extension LeadInEntryCoordinator: LeadInEntryStateManagerProtocol {
    func switchPageState(_ state:PageState) {
        DispatchQueue.main.async {
            self.store.dispatch(PageStateAction(state: state))
        }
    }

    func viewControllers() -> [UIViewController] {
        let mnemonicCoor = LeadInMnemonicCoordinator.init(rootVC: self.rootVC)
        let mnemonicVC = R.storyboard.leadIn.leadInMnemonicViewController()!
        mnemonicVC.coordinator = mnemonicCoor

        let priKeyCoor = LeadInKeyCoordinator.init(rootVC: self.rootVC)
        let leadInKeyVC = R.storyboard.leadIn.leadInKeyViewController()!
        leadInKeyVC.coordinator = priKeyCoor

        return [mnemonicVC, leadInKeyVC]
    }
}
