//
//  NormalContentCoordinator.swift
//  EOS
//
//  Created DKM on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

protocol NormalContentCoordinatorProtocol {
}

protocol NormalContentStateManagerProtocol {
    var state: NormalContentState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<NormalContentState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState
    
    func setData(_ sender : Int)
}

class NormalContentCoordinator: UserInfoRootCoordinator {
    
    lazy var creator = NormalContentPropertyActionCreate()
    
    var store = Store<NormalContentState>(
        reducer: NormalContentReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
}

extension NormalContentCoordinator: NormalContentCoordinatorProtocol {
    
}

extension NormalContentCoordinator: NormalContentStateManagerProtocol {
    var state: NormalContentState {
        return store.state
    }
    
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<NormalContentState>) -> Subscription<SelectedState>)?
        ) where S.StoreSubscriberStateType == SelectedState {
        store.subscribe(subscriber, transform: transform)
    }
    
    func setData(_ sender : Int) {
        var data = [String]()
        switch sender {
        case 0:data = [R.string.localizable.language_system(),R.string.localizable.language_cn(),R.string.localizable.language_en()]
        case 1:data = ["CNY","USD"]
        default:data = []
            break
        }
        
        self.store.dispatch(SetDataAction(data:data))
    }
    
}
