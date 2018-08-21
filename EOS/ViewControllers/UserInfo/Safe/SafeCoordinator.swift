//
//  SafeCoordinator.swift
//  EOS
//
//  Created DKM on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift
import BiometricAuthentication
import KRProgressHUD

protocol SafeCoordinatorProtocol {
    //MARK: - FaceId
    func openFaceIdLock(_ callback: @escaping (Bool) -> ())
    
    func closeFaceIdLock()
    
    //MARK: - FingerSinger
    func openFingerSingerLock(_ callback: @escaping (Bool) -> ())
    
    func closeFingerSingerLock()
    
    //MARK: - Gesture
    func openGestureLock(_ callback: @escaping (Bool) -> ())
    
    func closeGetureLock()
        
    //MARK: - Confirm
    func confirmFaceId(_ callback: @escaping (Bool) -> ())
    
    func confirmFingerSinger(_ callback: @escaping (Bool) -> ())
    
    func confirmGesture(_ callback: @escaping (Bool) -> ())
}

protocol SafeStateManagerProtocol {
    var state: SafeState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<SafeState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState
}

class SafeCoordinator: UserInfoRootCoordinator {
    
    lazy var creator = SafePropertyActionCreate()
    
    var store = Store<SafeState>(
        reducer: SafeReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
}

extension SafeCoordinator: SafeCoordinatorProtocol {
    //MARK: - FaceId
    func openFaceIdLock(_ callback: @escaping (Bool) -> ()) {
        SafeManager.shared.confirmFaceIdLock(R.string.localizable.faceid_reason.key.localized()) { (result) in
            callback(result)
        }
    }
    
    func closeFaceIdLock() {
        SafeManager.shared.closeFaceId()
    }
    
    //MARK: - FingerSinger
    func openFingerSingerLock(_ callback: @escaping (Bool) -> ()) {
        SafeManager.shared.confirmFingerSingerLock(R.string.localizable.fingerid_reason.key.localized()) { (result) in
            callback(result)
        }
    }
    
    func closeFingerSingerLock() {
        SafeManager.shared.closeFingerPrinter()
    }
    
    //MARK: - Gesture
    func openGestureLock(_ callback: @escaping (Bool) -> ()) {
        let gestureLockVC = R.storyboard.userInfo.gestureLockSetViewController()
        let coordinator = GestureLockSetCoordinator(rootVC: self.rootVC)
        gestureLockVC?.coordinator = coordinator
        self.rootVC.pushViewController(gestureLockVC!, animated: true)
        if let vc = coordinator.rootVC.topViewController as? GestureLockSetViewController {
            vc.coordinator?.state.callback.setResult.accept({[weak self] (result) in
                guard self != nil else { return }
                callback(result)
            })
        }
    }
    
    func closeGetureLock() {
        SafeManager.shared.closeGestureLock()
    }
    
    //MARK: - Confirm
    func confirmFaceId(_ callback: @escaping (Bool) -> ()) {
        let nav = BaseNavigationController()
        nav.navStyle = .clear
        let vc = R.storyboard.userInfo.faceIDComfirmViewController()!
        let faceIdCoordinator = FaceIDComfirmCoordinator(rootVC: nav)
        vc.coordinator = faceIdCoordinator
        nav.pushViewController(vc, animated: true)
        if let vc = faceIdCoordinator.rootVC.topViewController as? FaceIDComfirmViewController {
            vc.coordinator?.state.callback.confirmResult.accept({[weak self] (result) in
                guard self != nil else { return }
                callback(result)
            })
        }
        self.rootVC.present(nav, animated: true, completion: nil)
    }
    
    func confirmGesture(_ callback: @escaping (Bool) -> ()) {
        let nav = BaseNavigationController()
        nav.navStyle = .clear
        let vc = R.storyboard.userInfo.gestureLockComfirmViewController()!
        let gestureCoordinator = GestureLockComfirmCoordinator(rootVC: nav)
        vc.coordinator = gestureCoordinator
        nav.pushViewController(vc, animated: true)
        if let vc = gestureCoordinator.rootVC.topViewController as? GestureLockComfirmViewController {
            vc.coordinator?.state.callback.confirmResult.accept({[weak self] (result) in
                guard self != nil else { return }
                callback(result)
            })
        }
        self.rootVC.present(nav, animated: true, completion: nil)
    }
    
    func confirmFingerSinger(_ callback: @escaping (Bool) -> ()) {
        let nav = BaseNavigationController()
        nav.navStyle = .clear
        let vc = R.storyboard.userInfo.fingerPrinterConfirmViewController()!
        let fingerCoordinator = FingerPrinterConfirmCoordinator(rootVC: nav)
        vc.coordinator = fingerCoordinator
        nav.pushViewController(vc, animated: true)
        if let vc = fingerCoordinator.rootVC.topViewController as? FingerPrinterConfirmViewController {
            vc.coordinator?.state.callback.confirmResult.accept({[weak self] (result) in
                guard self != nil else { return }
                callback(result)
            })
        }
        self.rootVC.present(nav, animated: true, completion: nil)
    }
    
}

extension SafeCoordinator: SafeStateManagerProtocol {
    var state: SafeState {
        return store.state
    }
    
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<SafeState>) -> Subscription<SelectedState>)?
        ) where S.StoreSubscriberStateType == SelectedState {
        store.subscribe(subscriber, transform: transform)
    }
    
}
