//
//  OverviewCoordinator.swift
//  EOS
//
//  Created zhusongyu on 2018/10/30.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift
import NBLCommonModule

protocol OverviewCoordinatorProtocol {
    func pushToDetailVC()
}

protocol OverviewStateManagerProtocol {
    var state: OverviewState { get }
    
    func switchPageState(_ state:PageState)
}

class OverviewCoordinator: NavCoordinator {
    var store = Store(
        reducer: gOverviewReducer,
        state: nil,
        middleware:[trackingMiddleware]
    )
    
    var state: OverviewState {
        return store.state
    }
    
    override class func start(_ root: BaseNavigationController, context:RouteContext? = nil) -> BaseViewController {
        let vc = R.storyboard.home.overviewViewController()!
        let coordinator = OverviewCoordinator(rootVC: root)
        vc.coordinator = coordinator
        coordinator.store.dispatch(RouteContextAction(context: context))
        return vc
    }

    override func register() {
        Broadcaster.register(OverviewCoordinatorProtocol.self, observer: self)
        Broadcaster.register(OverviewStateManagerProtocol.self, observer: self)
    }
}

extension OverviewCoordinator: OverviewCoordinatorProtocol {
    func pushToDetailVC() {
        if let vc = R.storyboard.assetDetail.assetDetailViewController() {
            let coordinator = AssetDetailCoordinator(rootVC: self.rootVC)
            vc.coordinator = coordinator
            self.rootVC.pushViewController(vc, animated: true)
        }
    }
}

extension OverviewCoordinator: OverviewStateManagerProtocol {
    func switchPageState(_ state:PageState) {
        DispatchQueue.main.async {
            self.store.dispatch(PageStateAction(state: state))
        }
    }
}
