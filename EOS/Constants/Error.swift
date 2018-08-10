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
    
    case NBLCode(code: NBLNetworkErrorCode)
    
    var localizedDescription: String {
        switch self {
        case let .NBLCode(code):
            return code.desc()
        }
    }
}
