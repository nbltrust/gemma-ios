//
//  ScanCoordinator.swift
//  EOS
//
//  Created peng zhu on 2018/7/16.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

protocol ScanCoordinatorProtocol {
    func dismissVC()
}

protocol ScanStateManagerProtocol {
    var state: ScanState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<ScanState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState
    
    func updateScanResult(result: String)
}

class ScanCoordinator: NavCoordinator {
    
    lazy var creator = ScanPropertyActionCreate()
    
    var store = Store<ScanState>(
        reducer: ScanReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
    
    override class func start(_ root: BaseNavigationController) -> BaseViewController {
        let vc = ScanViewController()
        vc.subTitle = R.string.localizable.scan_subTitle.key.localized()
        let coordinator = ScanCoordinator(rootVC: root)
        vc.coordinator = coordinator
        return vc
    }

}

extension ScanCoordinator: ScanCoordinatorProtocol {
    func dismissVC() {
        self.rootVC.dismiss(animated: true, completion: nil)
    }
}

extension ScanCoordinator: ScanStateManagerProtocol {
    var state: ScanState {
        return store.state
    }
    
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<ScanState>) -> Subscription<SelectedState>)?
        ) where S.StoreSubscriberStateType == SelectedState {
        store.subscribe(subscriber, transform: transform)
    }
    
    func updateScanResult(result: String) {
        self.state.callback.scanResult.value?(result)
        self.dismissVC()
    }
    
}
