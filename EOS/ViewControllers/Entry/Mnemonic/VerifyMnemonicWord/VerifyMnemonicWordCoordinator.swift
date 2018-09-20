//
//  VerifyMnemonicWordCoordinator.swift
//  EOS
//
//  Created zhusongyu on 2018/9/13.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift
import NBLCommonModule
import Async

protocol VerifyMnemonicWordCoordinatorProtocol {
}

protocol VerifyMnemonicWordStateManagerProtocol {
    var state: VerifyMnemonicWordState { get }
    
    func switchPageState(_ state:PageState)
}

class VerifyMnemonicWordCoordinator: HomeRootCoordinator {
    var store = Store(
        reducer: VerifyMnemonicWordReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
    
    var state: VerifyMnemonicWordState {
        return store.state
    }
            
    override func register() {
        Broadcaster.register(VerifyMnemonicWordCoordinatorProtocol.self, observer: self)
        Broadcaster.register(VerifyMnemonicWordStateManagerProtocol.self, observer: self)
    }
}

extension VerifyMnemonicWordCoordinator: VerifyMnemonicWordCoordinatorProtocol {
    
}

extension VerifyMnemonicWordCoordinator: VerifyMnemonicWordStateManagerProtocol {
    func switchPageState(_ state:PageState) {
        Async.main {
            self.store.dispatch(PageStateAction(state: state))
        }
    }
}
