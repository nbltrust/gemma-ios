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
typealias StringOptionalCallback = (String?) -> Void
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
    static let NBL_BASE_TEST_URL = URL(string: "http://139.196.73.117:3002")!

    static let EOSIO_BASE_TEST_URL = URL(string: "http://47.75.154.248:50001")!//URL(string: "http://172.20.5.25:9999")!
    static let EOSIO_CANADA_TEST_URL = URL(string: "http://mainnet.eoscanada.com")!
    static let EOSIO_BASE_URL = URL(string: "http://139.196.73.117:8888")!
    static let EOS_BP_URL = URL(string: "https://eosweb.net")!

    static let EOSIO_DEFAULT_SYMBOL = "EOS"
    
    
    static let SERVER_BASE_URLString = "https://app.cybex.io/"
    static let ETH_PRICE = SERVER_BASE_URLString + "price"
}

struct EOSIOContract {
    static let TOKEN_CODE = "eosio.token"
    static let EOSIO_CODE = "eosio"
    static let EOSIO_SYSTEM_CODE = "eosio.system"
}

struct H5AddressConfiguration {
    static let GET_INVITECODE_URL = URL(string: "https://nebuladownload.oss-cn-beijing.aliyuncs.com/gemma/gemma_policy_cn.html")
    static let REGISTER_PROTOCOL_URL = URL(string: "https://nebuladownload.oss-cn-beijing.aliyuncs.com/gemma/gemma_policy_cn.html")
}

enum EOSAction:String {
    case transfer
    case delegatebw
    case undelegatebw
}

enum EOSIOTable:String {
    case producers
}
