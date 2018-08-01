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
    
    func setData(_ sender : Int ,callback:@escaping([String])->())
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
    
    func setData(_ sender : Int ,callback:@escaping([String])->()) {
        var data = [String]()
        switch sender {
        case 0:data = [R.string.localizable.language_system(),R.string.localizable.language_cn(),R.string.localizable.language_en()]
        case 1:data = ["CNY","USD"]
        case 2:data = ["https://mainnet-eos.token.im","https://api1-imtoken.eosasia.one","http://api-direct.eosasia.one","https://api.helloeos.com.cn"]
        default:
            break
        }
        callback(data)
//        self.store.dispatch(SetDataAction(data:data))
    }
    
}
