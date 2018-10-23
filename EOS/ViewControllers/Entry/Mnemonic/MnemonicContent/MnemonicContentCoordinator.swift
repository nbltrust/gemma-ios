//
//  MnemonicContentCoordinator.swift
//  EOS
//
//  Created zhusongyu on 2018/9/14.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift
import NBLCommonModule

protocol MnemonicContentCoordinatorProtocol {
    func pushToVerifyMnemonicVC()
}

protocol MnemonicContentStateManagerProtocol {
    var state: MnemonicContentState { get }
    
    func switchPageState(_ state:PageState)
    
    func getSeeds(_ success: @escaping GetSeedsComplication, failed: @escaping FailedComplication)
    
    func setSeeds(_ seeds: ([String],String))
}

class MnemonicContentCoordinator: NavCoordinator {
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
            vc.seeds = self.state.seedData.value.0
            vc.checkStr = self.state.seedData.value.1
            vc.coordinator = coordinator
            self.rootVC.pushViewController(vc, animated: true)
        }
    }
}

extension MnemonicContentCoordinator: MnemonicContentStateManagerProtocol {
    func switchPageState(_ state:PageState) {
        DispatchQueue.main.async {
            self.store.dispatch(PageStateAction(state: state))
        }
    }
    
    func getSeeds(_ success: @escaping GetSeedsComplication, failed: @escaping FailedComplication) {
        BLTWalletIO.shareInstance().getSeed(success, failed: failed)
    }
    
    func setSeeds(_ seeds: ([String],String)) {
        self.store.dispatch(SetSeedsAction(datas: seeds))
    }
}
