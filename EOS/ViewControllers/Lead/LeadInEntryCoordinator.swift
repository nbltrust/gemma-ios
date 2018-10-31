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
            if let leadInVC = self.rootVC.topViewController as? LeadInKeyViewController {
                leadInVC.leadInKeyView.textView.text = result
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
}
