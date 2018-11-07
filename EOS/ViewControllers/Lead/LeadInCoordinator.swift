//
//  LeadInCoordinator.swift
//  EOS
//
//  Created DKM on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift
import RxCocoa

protocol LeadInCoordinatorProtocol {
    func openLeadInKey()
}

protocol LeadInStateManagerProtocol {
    var state: LeadInState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<LeadInState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState
}

class LeadInCoordinator: NavCoordinator {

    lazy var creator = LeadInPropertyActionCreate()

    var store = Store<LeadInState>(
        reducer: gLeadInReducer,
        state: nil,
        middleware: [trackingMiddleware]
    )
}

extension LeadInCoordinator: LeadInCoordinatorProtocol {
    func openLeadInKey() {
        if let leadInEntryVC = R.storyboard.leadIn.leadInEntryViewController() {
            leadInEntryVC.coordinator = LeadInEntryCoordinator(rootVC: self.rootVC)
            self.rootVC.pushViewController(leadInEntryVC, animated: true)
        }
    }
}

extension LeadInCoordinator: LeadInStateManagerProtocol {
    var state: LeadInState {
        return store.state
    }

    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<LeadInState>) -> Subscription<SelectedState>)?
        ) where S.StoreSubscriberStateType == SelectedState {
        store.subscribe(subscriber, transform: transform)
    }

}
