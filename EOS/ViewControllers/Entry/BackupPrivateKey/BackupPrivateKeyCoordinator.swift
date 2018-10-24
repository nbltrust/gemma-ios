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

class BackupPrivateKeyCoordinator: NavCoordinator {

    lazy var creator = BackupPrivateKeyPropertyActionCreate()

    var store = Store<BackupPrivateKeyState>(
        reducer: BackupPrivateKeyReducer,
        state: nil,
        middleware: [trackingMiddleware]
    )
}

extension BackupPrivateKeyCoordinator: BackupPrivateKeyCoordinatorProtocol {
    func showPresenterVC(_ pubKey: String) {
        appCoodinator.showPresenterPwd(leftIconType: .dismiss, pubKey: pubKey, type: confirmType.backupPrivateKey.rawValue, producers: [], completion: {[weak self] (_) in
            guard let `self` = self else { return }
            let copyVC = CopyPriKeyViewController()
            let copyCoordinator = CopyPriKeyCoordinator(rootVC: self.rootVC)
            copyVC.coordinator = copyCoordinator
            self.rootVC.pushViewController(copyVC, animated: true)
        })

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
