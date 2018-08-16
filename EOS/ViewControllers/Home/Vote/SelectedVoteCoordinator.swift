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
    
    func updateAtIndexPath(_ indexPath: IndexPath, isSel: Bool)
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
            var lastSelData : [NodeVoteViewModel] = []
            for index in 0..<pro.state.property.selIndexPaths.count {
                lastSelData.append(pro.state.property.datas[index])
            }
            self.store.dispatch(SetSelIndexPathsAction(indexPaths: pro.state.property.selIndexPaths))
            self.store.dispatch(SetVoteNodeListAction(datas: lastSelData))
        }
    }
    
    func updateAtIndexPath(_ indexPath: IndexPath, isSel: Bool) {
        if let vc = self.rootVC.viewControllers[self.rootVC.viewControllers.count - 2] as? VoteViewController {
            if isSel {
                vc.voteTable.selectRow(at: self.state.property.indexPaths[indexPath.row], animated: false, scrollPosition: .none)
            } else {
                vc.voteTable.deselectRow(at: self.state.property.indexPaths[indexPath.row], animated: false)
            }
            vc.updateCount()
        }
    }
}
