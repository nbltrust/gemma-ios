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

protocol VerifyMnemonicWordCoordinatorProtocol {
    func popToVC(_ vc: UIViewController)
}

protocol VerifyMnemonicWordStateManagerProtocol {
    var state: VerifyMnemonicWordState { get }
    
    func switchPageState(_ state:PageState)
    
    func validSequence(_ datas: [String], compairDatas: [String]) -> Bool
    
    func checkSeed(_ seed: String, success: @escaping () -> Void, failed: @escaping (String?) -> Void)
    
    func checkFeedSuccessed()
}

class VerifyMnemonicWordCoordinator: NavCoordinator {
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
    func popToVC(_ vc: UIViewController) {
        self.rootVC.popToViewController(vc, animated: true)
    }
    
    
}

extension VerifyMnemonicWordCoordinator: VerifyMnemonicWordStateManagerProtocol {
    func switchPageState(_ state:PageState) {
        DispatchQueue.main.async {
            self.store.dispatch(PageStateAction(state: state))
        }
    }
    
    func validSequence(_ datas: [String], compairDatas: [String]) -> Bool {
        if datas.count != compairDatas.count {
            return false
        } else {
            for i in 0..<datas.count {
                if datas[i] != compairDatas[i] {
                    return false
                }
            }
        }
        return true
    }
    
    func checkSeed(_ seed: String, success: @escaping () -> Void, failed: @escaping (String?) -> Void) {
        BLTWalletIO.shareInstance().checkSeed(seed, success: success, failed: failed)
    }
    
    func checkFeedSuccessed() {
        self.rootVC.viewControllers.forEach { (vc) in
            if let entryVC = vc as? EntryViewController {
                self.popToVC(entryVC)
                entryVC.coordinator?.state.callback.finishBLTWalletCallback.value?()
            }
        }
    }
}
