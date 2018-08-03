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

class SafeManager {
    static let shared = SafeManager()
    
    let keychain = Keychain(service: SwifterSwift.appBundleID ?? "com.nbltrust.gemma")
    
    var gestureLockPassword = Defaults[.gestureLockPassword]
    
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
}
