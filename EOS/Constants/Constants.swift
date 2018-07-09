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
    
    
}

struct NetworkConfiguration {
    static let NBL_BASE_URL = URL(string: "http://139.196.73.117:3001")!
    static let EOSIO_BASE_URL = URL(string: "http://139.196.73.117:9000")!
    static let EOSIO_DEFAULT_CODE = "eosio.token"
    static let EOSIO_DEFAULT_SYMBOL = "EOS"
}

enum EOSAction:String {
    case transfer
}
