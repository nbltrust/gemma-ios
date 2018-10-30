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
    
    override class func start(_ root: BaseNavigationController, context:RouteContext? = nil) -> BaseViewController {
        let vc = R.storyboard.leadIn.leadInEntryViewController()!
        let coordinator = LeadInEntryCoordinator(rootVC: root)
        vc.coordinator = coordinator
        coordinator.store.dispatch(RouteContextAction(context: context))
        return vc
    }

    override func register() {
        Broadcaster.register(LeadInEntryCoordinatorProtocol.self, observer: self)
        Broadcaster.register(LeadInEntryStateManagerProtocol.self, observer: self)
    }
}

extension LeadInEntryCoordinator: LeadInEntryCoordinatorProtocol {
    
}

extension LeadInEntryCoordinator: LeadInEntryStateManagerProtocol {
    func switchPageState(_ state:PageState) {
        DispatchQueue.main.async {
            self.store.dispatch(PageStateAction(state: state))
        }
    }
}
