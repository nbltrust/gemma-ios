//
//  MnemonicContentCoordinator.swift
//  EOS
//
//  Created zhusongyu on 2018/9/14.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift
import SwiftNotificationCenter
import Async

protocol MnemonicContentCoordinatorProtocol {
    func pushToVerifyMnemonicVC()
}

protocol MnemonicContentStateManagerProtocol {
    var state: MnemonicContentState { get }
    
    func switchPageState(_ state:PageState)
}

class MnemonicContentCoordinator: HomeRootCoordinator {
    var store = Store(
        reducer: MnemonicContentReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
    
    var state: MnemonicContentState {
        return store.state
    }
            
    override func register() {
        Broadcaster.register(MnemonicContentCoordinatorProtocol.self, observer: self)
        Broadcaster.register(MnemonicContentStateManagerProtocol.self, observer: self)
    }
}

extension MnemonicContentCoordinator: MnemonicContentCoordinatorProtocol {
    func pushToVerifyMnemonicVC() {
        if let vc = R.storyboard.mnemonic.verifyMnemonicWordViewController() {
            let coordinator = VerifyMnemonicWordCoordinator(rootVC: self.rootVC)
            vc.coordinator = coordinator
            self.rootVC.pushViewController(vc, animated: true)
        }
    }
}

extension MnemonicContentCoordinator: MnemonicContentStateManagerProtocol {
    func switchPageState(_ state:PageState) {
        Async.main {
            self.store.dispatch(PageStateAction(state: state))
        }
    }
}
