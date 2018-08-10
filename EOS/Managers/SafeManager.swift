//
//  SafeManager.swift
//  EOS
//
//  Created by peng zhu on 2018/7/31.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import KeychainAccess
import SwifterSwift
import SwiftyUserDefaults
import BiometricAuthentication
import KRProgressHUD
import LocalAuthentication


class SafeManager {
    static let shared = SafeManager()
    
    let keychain = Keychain(service: SwifterSwift.appBundleID ?? "com.nbltrust.gemma")
    
    var gestureLockPassword = Defaults[.gestureLockPassword]
    
    //MARK: - Confirm
    func confirmFaceIdLock(_ reason: String, callback: @escaping (Bool) -> ()) {
        if self.biometricType() == .face {
            if BioMetricAuthenticator.shared.faceIDAvailable() {
                BioMetricAuthenticator.authenticateWithBioMetrics(reason: reason, success: {
                    self.openFaceId()
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
            KRProgressHUD.showError(withMessage: R.string.localizable.unsupport_faceid())
            callback(false)
        }
    }
    
    func confirmFingerSingerLock(_ reason: String, callback: @escaping (Bool) -> ()) {
        if self.biometricType() == .touch {
            BioMetricAuthenticator.authenticateWithPasscode(reason: R.string.localizable.fingerid_reason(), success: {
                self.openFingerPrinter()
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
            KRProgressHUD.showError(withMessage: R.string.localizable.unsupport_touchid())
            callback(false)
        }
    }
    
    //MARK: - FaceID
    func isFaceIdOpened() -> Bool {
        return Defaults[.isFaceIDOpened]
    }
    
    func openFaceId() {
        Defaults[.isFaceIDOpened] = true
    }
    
    func closeFaceId() {
        Defaults[.isFaceIDOpened] = false
    }
    
    //MARK: - FingerPrinter
    func isFingerPrinterLockOpened() -> Bool {
        return Defaults[.isFingerPrinterLockOpened]
    }
    
    func openFingerPrinter() {
        Defaults[.isFingerPrinterLockOpened] = true
    }
    
    func closeFingerPrinter() {
        Defaults[.isFingerPrinterLockOpened] = false
    }
    
    //MARK: - Gesture
    func isGestureLockOpened() -> Bool {
        return Defaults[.isGestureLockOpened]
    }
    
    func closeGestureLock() {
        try? keychain.remove("\(gestureLockPassword)-gestureLockPassword")
        Defaults[.isGestureLockOpened] = false
    }
    
    func getGestureLockPassword() -> String? {
        if let password = keychain[string: "\(gestureLockPassword)-gestureLockPassword"] {
            return password
        }
        return nil
    }
    
    func validGesturePassword(_ inputPassword: String) -> Bool {
        if let password = self.getGestureLockPassword() {
            return password == inputPassword
        }
        return false
    }
    
    func saveGestureLockPassword(_ password: String) {
        Defaults[.isGestureLockOpened] = true
        keychain[string: "\(gestureLockPassword)-gestureLockPassword"] = password
        Defaults[.isGestureLockOpened] = true
    }
    
    func biometricType() -> BiometricType {
        let authContext = LAContext()
        if #available(iOS 11, *) {
            let _ = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
            switch(authContext.biometryType) {
            case .none:
                return .none
            case .touchID:
                return .touch
            case .faceID:
                return .face
            }
        } else {
            return authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) ? .touch : .none
        }
    }
    
    enum BiometricType {
        case none
        case touch
        case face
    }
}
