//
//  BackupPrivateKeyCoordinator.swift
//  EOS
//
//  Created zhusongyu on 2018/8/1.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift
import Presentr

protocol BackupPrivateKeyCoordinatorProtocol {
    func showPresenterVC(_ pubKey: String)
}

protocol BackupPrivateKeyStateManagerProtocol {
    var state: BackupPrivateKeyState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<BackupPrivateKeyState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState
}

class BackupPrivateKeyCoordinator: EntryRootCoordinator {
    
    lazy var creator = BackupPrivateKeyPropertyActionCreate()
    
    var store = Store<BackupPrivateKeyState>(
        reducer: BackupPrivateKeyReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
}

extension BackupPrivateKeyCoordinator: BackupPrivateKeyCoordinatorProtocol {
    func showPresenterVC(_ pubKey: String) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.appcoordinator?.showPresenterPwd(leftIconType: .dismiss, pubKey: pubKey, completion: {[weak self] (result) in
                guard let `self` = self else { return }
                let copyVC = R.storyboard.home.priKeyViewController()
                let copyCoordinator = PriKeyCoordinator(rootVC: self.rootVC)
                copyVC?.coordinator = copyCoordinator
                self.rootVC.pushViewController(copyVC!, animated: true)
            })
            
        }
    }
}

extension BackupPrivateKeyCoordinator: BackupPrivateKeyStateManagerProtocol {
    var state: BackupPrivateKeyState {
        return store.state
    }
    
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<BackupPrivateKeyState>) -> Subscription<SelectedState>)?
        ) where S.StoreSubscriberStateType == SelectedState {
        store.subscribe(subscriber, transform: transform)
    }
    
}
