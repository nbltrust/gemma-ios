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
    func pushToPariWookongVC()
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
        reducer: gEntryGuideReducer,
        state: nil,
        middleware: [trackingMiddleware]
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
            if (UIApplication.shared.delegate as? AppDelegate) != nil {
                appCoodinator.endEntry()
            }
        }
        createVC.coordinator = coordinator
        self.rootVC.pushViewController(createVC, animated: true)
    }

    func pushToRecoverFromCopyVC() {
        let leadInVC = R.storyboard.leadIn.leadInViewController()!
        let coordinator = LeadInCoordinator(rootVC: self.rootVC)
        coordinator.state.callback.fadeCallback.accept {
            if (UIApplication.shared.delegate as? AppDelegate) != nil {
                appCoodinator.endEntry()
            }
        }
        leadInVC.coordinator = coordinator
        self.rootVC.pushViewController(leadInVC, animated: true)
    }

    func pushToPariWookongVC() {
        let bltEntryVC = R.storyboard.bltCard.bltCardEntryViewController()!
        let coordinator = BLTCardEntryCoordinator(rootVC: self.rootVC)
        bltEntryVC.coordinator = coordinator
        self.rootVC.pushViewController(bltEntryVC, animated: true)
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
