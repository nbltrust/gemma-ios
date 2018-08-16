//
//  SelectedVoteCoordinator.swift
//  EOS
//
//  Created peng zhu on 2018/8/13.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift
import SwiftNotificationCenter

protocol SelectedVoteCoordinatorProtocol {
}

protocol SelectedVoteStateManagerProtocol {
    var state: SelectedVoteState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<SelectedVoteState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState
    
    func loadDatas()
}

class SelectedVoteCoordinator: HomeRootCoordinator {
    lazy var creator = SelectedVotePropertyActionCreate()

    var store = Store<SelectedVoteState>(
        reducer: SelectedVoteReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
        
    override func register() {
        Broadcaster.register(SelectedVoteCoordinatorProtocol.self, observer: self)
        Broadcaster.register(SelectedVoteStateManagerProtocol.self, observer: self)
    }
}

extension SelectedVoteCoordinator: SelectedVoteCoordinatorProtocol {
    
}

extension SelectedVoteCoordinator: SelectedVoteStateManagerProtocol {
    var state: SelectedVoteState {
        return store.state
    }
    
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<SelectedVoteState>) -> Subscription<SelectedState>)?
        ) where S.StoreSubscriberStateType == SelectedState {
        store.subscribe(subscriber, transform: transform)
    }
    
    func loadDatas() {
        Broadcaster.notify(VoteStateManagerProtocol.self) { (pro) in
            self.store.dispatch(SetVoteNodeListAction(datas: pro.state.property.datas))
        }
    }
}
