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
    
    func closeFaceIdLock(_ callback: @escaping (Bool) -> ())
    
    //MARK: - FingerSinger
    func openFingerSingerLock(_ callback: @escaping (Bool) -> ())
    
    func closeFingerSingerLock(_ callback: @escaping (Bool) -> ())
    
    //MARK: - Gesture
    func openGestureLock()
    
    func closeGetureLock()
    
    func updateGesturePassword()
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
        if BioMetricAuthenticator.canAuthenticate() {
            if BioMetricAuthenticator.shared.faceIDAvailable() {
                BioMetricAuthenticator.authenticateWithBioMetrics(reason: R.string.localizable.faceid_reason(), success: {
                    SafeManager.shared.openFaceId()
                    callback(true)
                }) { (error) in
                    if error == .canceledByUser || error == .canceledBySystem || error == .fallback {
                        callback(false)
                    } else {
                        KRProgressHUD.showError(withMessage: error.message())
                        callback(false)
                    }
                }
            } else {
                KRProgressHUD.showError(withMessage: R.string.localizable.unsupport_faceid())
                callback(false)
            }
        } else {
            KRProgressHUD.showError(withMessage: R.string.localizable.guide_open_faceid())
            callback(false)
        }
    }
    
    func closeFaceIdLock(_ callback: @escaping (Bool) -> ()) {
        SafeManager.shared.closeFaceId()
        callback(true)
    }
    
    //MARK: - FingerSinger
    func openFingerSingerLock(_ callback: @escaping (Bool) -> ()) {
        if BioMetricAuthenticator.canAuthenticate() {
            BioMetricAuthenticator.authenticateWithPasscode(reason: R.string.localizable.fingerid_reason(), success: {
                SafeManager.shared.openFingerPrinter()
                callback(true)
            }) { (error) in
                if error == .canceledByUser || error == .canceledBySystem || error == .fallback {
                    callback(false)
                } else {
                    KRProgressHUD.showError(withMessage: error.message())
                    callback(false)
                }
            }
        } else {
            KRProgressHUD.showError(withMessage: R.string.localizable.guide_open_finger())
            callback(false)
        }
    }
    
    func closeFingerSingerLock(_ callback: @escaping (Bool) -> ()) {
        SafeManager.shared.closeFingerPrinter()
        callback(true)
    }
    
    //MARK: - Gesture
    func openGestureLock() {
        let gestureLockVC = R.storyboard.userInfo.gestureLockSetViewController()
        let coordinator = GestureLockSetCoordinator(rootVC: self.rootVC)
        gestureLockVC?.coordinator = coordinator
        self.rootVC.pushViewController(gestureLockVC!, animated: true)
    }
    
    func closeGetureLock() {
        SafeManager.shared.closeGestureLock()
    }
    
    func updateGesturePassword() {
        
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
