//
//  LeadInKeyCoordinator.swift
//  EOS
//
//  Created DKM on 2018/7/31.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

protocol LeadInKeyCoordinatorProtocol {
    func openScan()

    func openSetWallet()
}

protocol LeadInKeyStateManagerProtocol {
    var state: LeadInKeyState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<LeadInKeyState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState
    
    func validPrivateKey(_ privKey: String) -> (Bool, String)
    func importPrivKey(_ privKey: String)
}

class LeadInKeyCoordinator: HomeRootCoordinator {
    
    lazy var creator = LeadInKeyPropertyActionCreate()
    
    var store = Store<LeadInKeyState>(
        reducer: LeadInKeyReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
}

extension LeadInKeyCoordinator: LeadInKeyCoordinatorProtocol {
    func openScan() {
        let vc = BaseNavigationController()
        vc.navStyle = .clear
        let scanCoordinator = ScanRootCoordinator(rootVC: vc)
        scanCoordinator.start()
        if let vc = scanCoordinator.rootVC.topViewController as? ScanViewController {
            vc.coordinator?.state.callback.scanResult.accept({[weak self] (result) in
                if let leadInVC = self?.rootVC.topViewController as? LeadInKeyViewController {
                    leadInVC.leadInKeyView.textView.text = result
                }
            })
        }
        self.rootVC.present(vc, animated: true, completion: nil)
    }
    
    func openSetWallet() {
        if let vc = R.storyboard.leadIn.setWalletViewController() {
            vc.coordinator = SetWalletCoordinator(rootVC: self.rootVC)
            self.rootVC.pushViewController(vc, animated: true)
        }
    }
}

extension LeadInKeyCoordinator: LeadInKeyStateManagerProtocol {
    var state: LeadInKeyState {
        return store.state
    }
    
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<LeadInKeyState>) -> Subscription<SelectedState>)?
        ) where S.StoreSubscriberStateType == SelectedState {
        store.subscribe(subscriber, transform: transform)
    }
    
    func validPrivateKey(_ privKey: String) -> (Bool, String) {
        return (true, "")
    }
    
    func importPrivKey(_ privKey: String) {
        WalletManager.shared.addPrivatekey(privKey)
    }
}
