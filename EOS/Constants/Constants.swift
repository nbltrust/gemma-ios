//
//  Constants.swift
//  EOS
//
//  Created by koofrank on 2018/7/4.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import SwifterSwift

struct AppConfiguration {
    static let APPID = ""
    
    static let EOS_PRECISION = 4
}

struct NetworkConfiguration {
    static let NBL_BASE_URL = URL(string: "http://139.196.73.117:3001")!
    static let EOSIO_BASE_URL = URL(string: "http://139.196.73.117:9000")!
    static let EOSIO_DEFAULT_CODE = "eosio.token"
    static let EOSIO_DEFAULT_SYMBOL = "EOS"
    
    
    static let SERVER_BASE_URLString = "https://app.cybex.io/"
    static let ETH_PRICE = SERVER_BASE_URLString + "price"
}

enum NetworkError: Error {
//    case invitecodeRegitered   = "10002"
//    case invitecodeInexistence = "10003"
//    case accountRegistered     = "10004"
//    case accountInValid        = "10005"
//    case accountWrongLength    = "10006"
//    case parameterError        = "10007"
//    case invalidPubKey         = "10008"
}

enum EOSAction:String {
    case transfer
}
