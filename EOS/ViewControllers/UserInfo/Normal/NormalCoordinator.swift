//
//  NormalCoordinator.swift
//  EOS
//
//  Created DKM on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

protocol NormalCoordinatorProtocol {
    func openContent(_ sender : Int)
}

protocol NormalStateManagerProtocol {
    var state: NormalState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<NormalState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState
}

class NormalCoordinator: UserInfoRootCoordinator {
    
    lazy var creator = NormalPropertyActionCreate()
    
    var store = Store<NormalState>(
        reducer: NormalReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
}

extension NormalCoordinator: NormalCoordinatorProtocol {
    func openContent(_ sender : Int) {
        if let vc = R.storyboard.userInfo.normalContentViewController() ,let type = NormalContentViewController.vc_type(rawValue: sender){
            vc.coordinator = NormalContentCoordinator(rootVC: self.rootVC)
            vc.type = type
            self.rootVC.pushViewController(vc, animated: true)
        }
    }
}

extension NormalCoordinator: NormalStateManagerProtocol {
    var state: NormalState {
        return store.state
    }
    
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<NormalState>) -> Subscription<SelectedState>)?
        ) where S.StoreSubscriberStateType == SelectedState {
        store.subscribe(subscriber, transform: transform)
    }
    
}
