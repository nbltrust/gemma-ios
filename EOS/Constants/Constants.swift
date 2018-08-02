//
//  Constants.swift
//  EOS
//
//  Created by koofrank on 2018/7/4.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import SwifterSwift

typealias CompletionCallback = () -> Void
typealias StringCallback = (String) -> Void
typealias StringOptionalCallback = (String) -> Void
typealias ObjectCallback = (Any) -> Void
typealias ObjectOptionalCallback = (Any?) -> Void

typealias ResultCallback = (Bool) -> Void
typealias HandlerResult = (Bool, String)

struct AppConfiguration {
    static let APPID = ""
    
    static let EOS_PRECISION = 4
}

struct NetworkConfiguration {
    static let NBL_BASE_URL = URL(string: "http://139.196.73.117:3001")!

    static let EOSIO_BASE_TEST_URL = URL(string: "http://139.224.135.236:18888")!//URL(string: "http://172.20.5.25:9999")!
    static let EOSIO_BASE_URL = URL(string: "http://139.196.73.117:8888")!
    static let EOS_BP_URL = URL(string: "https://eosweb.net")!

    static let EOSIO_DEFAULT_CODE = "eosio.token"
    static let EOSIO_DEFAULT_SYMBOL = "EOS"
    
    
    static let SERVER_BASE_URLString = "https://app.cybex.io/"
    static let ETH_PRICE = SERVER_BASE_URLString + "price"
}

struct H5AddressConfiguration {
    static let GET_INVITECODE_URL = URL(string: "https://nebuladownload.oss-cn-beijing.aliyuncs.com/gemma/gemma_policy_cn.html")
    static let REGISTER_PROTOCOL_URL = URL(string: "https://nebuladownload.oss-cn-beijing.aliyuncs.com/gemma/gemma_policy_cn.html")
}

enum GemmaError: Error {
    enum NBLNetworkErrorCode: Int {
        case invitecodeRegiteredCode   = 10002
        case invitecodeInexistenceCode = 10003
        case accountRegisteredCode     = 10004
        case accountInValidCode        = 10005
        case accountWrongLengthCode    = 10006
        case parameterWrongCode        = 10007
        case invalidPubKeyCode         = 10008
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

enum EOSAction:String {
    case transfer
}
