//
//  LeadInMnemonicCoordinator.swift
//  EOS
//
//  Created peng zhu on 2018/10/30.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift
import NBLCommonModule

protocol LeadInMnemonicCoordinatorProtocol {
}

protocol LeadInMnemonicStateManagerProtocol {
    var state: LeadInMnemonicState { get }
    
    func switchPageState(_ state:PageState)
}

class LeadInMnemonicCoordinator: NavCoordinator {
    var store = Store(
        reducer: gLeadInMnemonicReducer,
        state: nil,
        middleware:[trackingMiddleware]
    )
    
    var state: LeadInMnemonicState {
        return store.state
    }
    
    override class func start(_ root: BaseNavigationController, context:RouteContext? = nil) -> BaseViewController {
        let vc = R.storyboard.leadIn.leadInMnemonicViewController()!
        let coordinator = LeadInMnemonicCoordinator(rootVC: root)
        vc.coordinator = coordinator
        coordinator.store.dispatch(RouteContextAction(context: context))
        return vc
    }

    override func register() {
        Broadcaster.register(LeadInMnemonicCoordinatorProtocol.self, observer: self)
        Broadcaster.register(LeadInMnemonicStateManagerProtocol.self, observer: self)
    }
}

extension LeadInMnemonicCoordinator: LeadInMnemonicCoordinatorProtocol {
    
}

extension LeadInMnemonicCoordinator: LeadInMnemonicStateManagerProtocol {
    func switchPageState(_ state:PageState) {
        DispatchQueue.main.async {
            self.store.dispatch(PageStateAction(state: state))
        }
    }
}
