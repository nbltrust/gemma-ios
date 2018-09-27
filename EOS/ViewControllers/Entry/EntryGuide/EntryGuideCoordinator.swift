//
//  EntryGuideCoordinator.swift
//  EOS
//
//  Created peng zhu on 2018/7/12.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift
import SwifterSwift

protocol EntryGuideCoordinatorProtocol {
    func pushToCreateWalletVC()
    func pushToRecoverFromCopyVC()

}

protocol EntryGuideStateManagerProtocol {
    var state: EntryGuideState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<EntryGuideState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState
}

class EntryGuideCoordinator: NavCoordinator {
    
    lazy var creator = EntryGuidePropertyActionCreate()
    
    var store = Store<EntryGuideState>(
        reducer: EntryGuideReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
    
    override class func start(_ root: BaseNavigationController, context: RouteContext? = nil) -> BaseViewController {
        let vc = R.storyboard.entry.entryGuideViewController()!
        let coordinator = EntryGuideCoordinator(rootVC: root)
        vc.coordinator = coordinator
        coordinator.store.dispatch(RouteContextAction(context: context))
        return vc
    }
}

extension EntryGuideCoordinator: EntryGuideCoordinatorProtocol {
    func pushToCreateWalletVC() {
        let createVC = R.storyboard.entry.entryViewController()!
        let coordinator = EntryCoordinator(rootVC: self.rootVC)
        coordinator.state.callback.endCallback.accept {
            if let appdelegate = UIApplication.shared.delegate as? AppDelegate {
                app_coodinator.endEntry()
            }
        }
        createVC.coordinator = coordinator
        self.rootVC.pushViewController(createVC, animated: true)
    }
    
    func pushToRecoverFromCopyVC() {
        let leadInVC = R.storyboard.leadIn.leadInViewController()!
        let coordinator = LeadInCoordinator(rootVC: self.rootVC)
        coordinator.state.callback.fadeCallback.accept {
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                app_coodinator.endEntry()
            }
        }
        leadInVC.coordinator = coordinator
        self.rootVC.pushViewController(leadInVC, animated: true)
    }
}

extension EntryGuideCoordinator: EntryGuideStateManagerProtocol {
    var state: EntryGuideState {
        return store.state
    }
    
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<EntryGuideState>) -> Subscription<SelectedState>)?
        ) where S.StoreSubscriberStateType == SelectedState {
        store.subscribe(subscriber, transform: transform)
    }
}
