//
//  ResourceDetailCoordinator.swift
//  EOS
//
//  Created zhusongyu on 2018/11/1.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift
import NBLCommonModule

protocol ResourceDetailCoordinatorProtocol {
//    func 
}

protocol ResourceDetailStateManagerProtocol {
    var state: ResourceDetailState { get }
    
    func switchPageState(_ state:PageState)
}

class ResourceDetailCoordinator: NavCoordinator {
    var store = Store(
        reducer: gResourceDetailReducer,
        state: nil,
        middleware:[trackingMiddleware]
    )
    
    var state: ResourceDetailState {
        return store.state
    }
    
    override class func start(_ root: BaseNavigationController, context:RouteContext? = nil) -> BaseViewController {
        let vc = R.storyboard.resourceMortgage.resourceDetailViewController()!
        let coordinator = ResourceDetailCoordinator(rootVC: root)
        vc.coordinator = coordinator
        coordinator.store.dispatch(RouteContextAction(context: context))
        return vc
    }

    override func register() {
        Broadcaster.register(ResourceDetailCoordinatorProtocol.self, observer: self)
        Broadcaster.register(ResourceDetailStateManagerProtocol.self, observer: self)
    }
}

extension ResourceDetailCoordinator: ResourceDetailCoordinatorProtocol {
    
}

extension ResourceDetailCoordinator: ResourceDetailStateManagerProtocol {
    func switchPageState(_ state:PageState) {
        DispatchQueue.main.async {
            self.store.dispatch(PageStateAction(state: state))
        }
    }
}
