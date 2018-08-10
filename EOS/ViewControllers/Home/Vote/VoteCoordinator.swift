//
//  VoteCoordinator.swift
//  EOS
//
//  Created peng zhu on 2018/8/8.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift
import SwiftNotificationCenter

protocol VoteCoordinatorProtocol {
}

protocol VoteStateManagerProtocol {
    var state: VoteState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<VoteState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState
    
    func loadVoteList(_ completed: @escaping (Bool) -> ())
}

class VoteCoordinator: HomeRootCoordinator {
    lazy var creator = VotePropertyActionCreate()
    
    var store = Store<VoteState>(
        reducer: VoteReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
        
    override func register() {
        Broadcaster.register(VoteCoordinatorProtocol.self, observer: self)
        Broadcaster.register(VoteStateManagerProtocol.self, observer: self)
    }
}

extension VoteCoordinator: VoteCoordinatorProtocol {
    
}

extension VoteCoordinator: VoteStateManagerProtocol {
    func loadVoteList(_ completed: @escaping (Bool) -> ()) {
        let producer = TableProducers()
        if let str = producer.toJSONString() {
            EOSIONetwork.request(target: .get_producers(json: str), success: {[weak self] (json) in
                
            }, error: { (code) in
                completed(false)
            }, failure: { (error) in
                completed(false)
            })
        }
    }
    
    var state: VoteState {
        return store.state
    }
    
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<VoteState>) -> Subscription<SelectedState>)?
        ) where S.StoreSubscriberStateType == SelectedState {
        store.subscribe(subscriber, transform: transform)
    }
    
}
