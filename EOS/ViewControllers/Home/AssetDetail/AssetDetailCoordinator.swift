//
//  AssetDetailCoordinator.swift
//  EOS
//
//  Created zhusongyu on 2018/10/30.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift
import NBLCommonModule

protocol AssetDetailCoordinatorProtocol {
    func pushResourceMortgageVC()
    func pushVoteVC()
    func pushTransferVC()
}

protocol AssetDetailStateManagerProtocol {
    var state: AssetDetailState { get }
    
    func switchPageState(_ state:PageState)
}

class AssetDetailCoordinator: NavCoordinator {
    var store = Store(
        reducer: gAssetDetailReducer,
        state: nil,
        middleware:[trackingMiddleware]
    )
    
    var state: AssetDetailState {
        return store.state
    }
    override class func start(_ root: BaseNavigationController, context:RouteContext? = nil) -> BaseViewController {
        let vc = R.storyboard.assetDetail.assetDetailViewController()!
        let coordinator = AssetDetailCoordinator(rootVC: root)
        vc.coordinator = coordinator
        coordinator.store.dispatch(RouteContextAction(context: context))
        return vc
    }

    override func register() {
        Broadcaster.register(AssetDetailCoordinatorProtocol.self, observer: self)
        Broadcaster.register(AssetDetailStateManagerProtocol.self, observer: self)
    }
}

extension AssetDetailCoordinator: AssetDetailCoordinatorProtocol {
    func pushResourceMortgageVC() {
        if let rmVC = R.storyboard.resourceMortgage.resourceMortgageViewController() {
            let coordinator = ResourceMortgageCoordinator(rootVC: self.rootVC)
            rmVC.coordinator = coordinator
            self.rootVC.pushViewController(rmVC, animated: true)
        }
    }
    func pushVoteVC() {
        if let vodeVC = R.storyboard.home.voteViewController() {
            let coordinator = VoteCoordinator(rootVC: self.rootVC)
            vodeVC.coordinator = coordinator
            self.rootVC.pushViewController(vodeVC, animated: true)
        }
    }
    func pushTransferVC() {
        if let transferVC = R.storyboard.transfer.transferViewController() {
            let coordinator = TransferCoordinator(rootVC: self.rootVC)
            transferVC.coordinator = coordinator
            self.rootVC.pushViewController(transferVC, animated: true)
        }
    }
}

extension AssetDetailCoordinator: AssetDetailStateManagerProtocol {
    func switchPageState(_ state:PageState) {
        DispatchQueue.main.async {
            self.store.dispatch(PageStateAction(state: state))
        }
    }
}
