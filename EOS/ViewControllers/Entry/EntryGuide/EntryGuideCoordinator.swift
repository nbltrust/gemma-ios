//
//  EntryGuideCoordinator.swift
//  EOS
//
//  Created peng zhu on 2018/7/12.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift
import SwifterSwift

protocol EntryGuideCoordinatorProtocol {
    func pushToCreateWalletVC()
    func pushToRecoverFromCopyVC()
}

protocol EntryGuideStateManagerProtocol {
    var state: EntryGuideState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<EntryGuideState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState
}

class EntryGuideCoordinator: EntryRootCoordinator {
    
    lazy var creator = EntryGuidePropertyActionCreate()
    
    var store = Store<EntryGuideState>(
        reducer: EntryGuideReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
}

extension EntryGuideCoordinator: EntryGuideCoordinatorProtocol {
    func pushToCreateWalletVC() {
        let createVC = R.storyboard.entry.entryViewController()!
        let coordinator = EntryCoordinator(rootVC: self.rootVC)
        createVC.coordinator = coordinator
        self.rootVC.pushViewController(createVC, animated: true)
    }
    
    func pushToRecoverFromCopyVC() {
        self.testGesture()
    }
    
    func testGesture() {
        let nav = BaseNavigationController()
        let gestureCoordinator = GestureLockRootCoordinator(rootVC: nav)
        gestureCoordinator.lockMode = .set
        gestureCoordinator.start()
        
        SwifterSwift.delay(milliseconds: 100) {
            self.rootVC.present(nav, animated: true, completion: nil)
        }
    }
    
    func testScan() {
        let nav = BaseNavigationController()
        nav.navStyle = .clear
        let scanCoordinator = ScanRootCoordinator(rootVC: nav)
        scanCoordinator.start()
        
        SwifterSwift.delay(milliseconds: 100) {
            self.rootVC.present(nav, animated: true, completion: nil)
        }
    }
}

extension EntryGuideCoordinator: EntryGuideStateManagerProtocol {
    var state: EntryGuideState {
        return store.state
    }
    
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<EntryGuideState>) -> Subscription<SelectedState>)?
        ) where S.StoreSubscriberStateType == SelectedState {
        store.subscribe(subscriber, transform: transform)
    }
}
