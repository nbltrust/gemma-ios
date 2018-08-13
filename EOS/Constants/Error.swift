//
//  Error.swift
//  EOS
//
//  Created by peng zhu on 2018/8/9.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import Foundation

enum GemmaError: Error {
    enum NBLNetworkErrorCode: Int {
        case invitecodeRegiteredCode   = 10002
        case invitecodeInexistenceCode = 10003
        case accountRegisteredCode     = 10004
        case accountInValidCode        = 10005
        case accountWrongLengthCode    = 10006
        case parameterWrongCode        = 10007
        case invalidPubKeyCode         = 10008
        case retryFailCode             = 10013
        case balanceNotEnoughCode      = 20001
        case creatAccountFailedCode    = 20002
        
        func desc() -> String {
            switch self {
            case .invitecodeRegiteredCode:
                return R.string.localizable.error_invitecode_regitered()
            case .invitecodeInexistenceCode:
                return R.string.localizable.error_invitecode_inexistence()
            case .accountRegisteredCode:
                return R.string.localizable.error_account_registered()
            case .accountInValidCode:
                return R.string.localizable.error_account_invalid()
            case .accountWrongLengthCode:
                return R.string.localizable.error_account_wronglength()
            case .parameterWrongCode:
                return R.string.localizable.error_parameter_wrong()
            case .invalidPubKeyCode:
                return R.string.localizable.error_invalid_pubkey()
            case .balanceNotEnoughCode:
                return R.string.localizable.error_balance_unenough()
            case .creatAccountFailedCode:
                return R.string.localizable.error_createAccount_failed()
            default:
                return ""
            }
        }
        
    }
    
    enum AuthErrorCode: Int {
        //MARK: Face ID
        case faceIdUnSupport         = 30001
        case faceIdAuthFailed        = 30002
        case faceIdAuthNotSet        = 30003
        case faceIdAuthNotAvailible  = 30004
        case faceIdAuthLock          = 30005
        case faceIdAuthNotEnrolled   = 30006
        //MARK: Touch ID
        case touchIdUnSupport        = 30007
        case touchIdAuthFailed       = 30008
        case touchIdAuthNotSet       = 30009
        case touchIdAuthNotAvailible = 30010
        case touchIdAuthLock         = 30011
        case touchIdAuthNotEnrolled  = 30012
        //MARK: Camera
        case cameraUnSupport         = 30013
        case cameraNotOpen           = 30014
        
        func desc() -> String {
            switch self {
            case .faceIdUnSupport:
                return R.string.localizable.unsupport_faceid()
            case .faceIdAuthFailed:
                return R.string.localizable.faceid_auth_failed()
            case .faceIdAuthNotSet:
                return R.string.localizable.faceid_start_failed()
            case .faceIdAuthNotAvailible:
                return R.string.localizable.faceid_start_failed()
            case .faceIdAuthLock:
                return R.string.localizable.faceid_auth_lock()
            case .faceIdAuthNotEnrolled:
                return R.string.localizable.faceid_start_failed()
            case .touchIdUnSupport:
                return R.string.localizable.unsupport_touchid()
            case .touchIdAuthFailed:
                return R.string.localizable.touchid_auth_failed()
            case .touchIdAuthNotSet:
                return R.string.localizable.touchid_start_failed()
            case .touchIdAuthNotAvailible:
                return R.string.localizable.touchid_start_failed()
            case .touchIdAuthLock:
                return R.string.localizable.touchid_auth_lock()
            case .touchIdAuthNotEnrolled:
                return R.string.localizable.touchid_start_failed()
            case .cameraUnSupport:
                return R.string.localizable.unsupport_camera()
            case .cameraNotOpen:
                return R.string.localizable.guide_open_camera()
            default:
                return ""
            }
        }
    }
    
    
    case NBLCode(code: NBLNetworkErrorCode)
    
    var localizedDescription: String {
        switch self {
        case let .NBLCode(code):
            return code.desc()
        }
    }
}
