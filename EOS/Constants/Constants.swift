//
//  Constants.swift
//  EOS
//
//  Created by koofrank on 2018/7/4.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import SwifterSwift
import SwiftyUserDefaults

typealias CompletionCallback = () -> Void
typealias StringCallback = (String) -> Void
typealias StringOptionalCallback = (String?) -> Void
typealias ObjectCallback = (Any) -> Void
typealias ObjectOptionalCallback = (Any?) -> Void

typealias ResultCallback = (Bool) -> Void
typealias HandlerResult = (Bool, String)

var appCoodinator: AppCoordinator {
    return AppConfiguration.shared.appCoordinator
}

struct AppConfiguration {
    static let APPID = ""

    static let EOS_PRECISION = 4

    static let EOS_ERROR_CODE_BASE = "eos_errorcode_"

    static let shared = AppConfiguration()
    var appCoordinator: AppCoordinator!

    private init() {
        let rootVC = BaseTabbarViewController()
        appCoordinator = AppCoordinator(rootVC: rootVC)
    }
}

struct NetworkConfiguration {
    static let NBL_BASE_URL = URL(string: "http://139.196.73.117:3001")!
    static let NBL_BASE_TEST_URL = URL(string: "http://139.196.73.117:3002")!

    static let EOSIO_BASE_TEST_URL = URL(string: "http://139.224.135.236:18888")!//URL(string: "http://172.20.5.25:9999")!
    static let EOSIO_CANADA_TEST_URL = URL(string: "http://mainnet.eoscanada.com")!
    var EOSIO_BASE_URL: URL {
        get {
            var index = Defaults[.currentURLNode]
            let urls = EOSBaseURLNodesConfiguration.values
            if index < 0 || index >= urls.count {
                index = 0
            }
            return URL(string: urls[index])!
        }
    }
    var EOSIO_OTHER_BASE_URL: URL {
        get {
            let index = Defaults[.currentURLNode]
            var urls = EOSBaseURLNodesConfiguration.values
            if index >= 0 && index < urls.count {
                urls.remove(at: index)
            }
            let temp = Int(arc4random() % uint(urls.count))
            return URL(string: urls[temp])!
        }
    }
    //URL(string: "http://139.196.73.117:8888")!
    static let EOS_BP_URL = URL(string: "https://eosweb.net")!

    static let EOSIO_DEFAULT_SYMBOL = "EOS"
    static let USDT_DEFAULT_SYMBOL = "USDT"
    static let BALANCE_DEFAULT_SYMBOL = "balance"
    static let RAMPRICE_DEFAULT_SYMBOL = "ramprice"

    static let EOSFLARE_BASE_URLString = "https://eosflare.io/tx/"

    static let SERVER_BASE_URLString = "https://app.cybex.io/"
    static let ETH_PRICE = SERVER_BASE_URLString + "price"
}

//Laguage Setting
struct LanguageConfiguration {
    var keys = [R.string.localizable.language_system.key.localized(),
                       R.string.localizable.language_cn.key.localized(),
                       R.string.localizable.language_en.key.localized()]

    func valueWithIndex(_ index: Int) -> String {
        if index == 1 {
            return "zh-Hans"
        } else if index == 2 {
            return "en"
        }
        return ""
    }

    func indexWithValue(_ value: String) -> Int {
        if value == "zh-Hans" {
            return 1
        } else if value == "en" {
            return 2
        }
        return 0
    }
}

//Coin Setting
struct CoinUnitConfiguration {
    static let values = ["CNY", "USD"]
}

enum CoinType: Int {
    case CNY = 0
    case USD
}

//Node Datas
struct EOSBaseURLNodesConfiguration {
    static let values = [
        "http://47.75.154.248:50003",
                         "http://52.77.177.200:8888",
                         "http://api-mainnet.starteos.io",
                         "https://api.eosnewyork.io",
                         "https://eos.greymass.com",
                         "https://api-direct.eosasia.one",
                         "https://api-mainnet.eosgravity.com",
                         "https://api.helloeos.com.cn",
                         "https://api.hkeos.com",
                         "https://nodes.eos42.io",
                         "https://api.cypherglass.com"]
}

struct EOSIOContract {
    static let TOKEN_CODE = "eosio.token"
    static let EOSIO_CODE = "eosio"
    static let EOSIO_SYSTEM_CODE = "eosio.system"
}

struct H5AddressConfiguration {
    static let GET_INVITECODE_URL = URL(string: "https://nebuladownload.oss-cn-beijing.aliyuncs.com/gemma/gemma_policy_cn.html")
    static let REGISTER_PROTOCOL_URL = URL(string: "https://nebuladownload.oss-cn-beijing.aliyuncs.com/gemma/gemma_policy_cn.html")
    static let HELP_CN_URL = URL(string: "https://cdn.nbltrust.com/gemma/gemma_policy_cn.html")
    static let HELP_EN_URL = URL(string: "https://cdn.nbltrust.com/gemma/gemma_policy_en.html")
    static let RELEASE_NOTES_CN_URL = URL(string: "https://cdn.nbltrust.com/gemma/gemma_release_desc_cn.html")
    static let RELEASE_NOTES_EN_URL = URL(string: "https://cdn.nbltrust.com/gemma/gemma_release_desc_en.html")
    static let FEEDBACK_CN_URL = URL(string: "http://47.75.154.39:3009/gemma?lang=cn")
    static let FEEDBACK_EN_URL = URL(string: "http://47.75.154.39:3009/gemma?lang=en")
}

enum EOSAction: String {
    case transfer
    case bltTransfer
    case delegatebw
    case undelegatebw
    case buyram
    case sellram
    case voteproducer
}

enum EOSIOTable: String {
    case producers
    case rammarket
}

enum WifiStatus: String {
    case unknown
    case notReachable
    case wwan
    case wifi
}

struct Unit {
    static let USD_UNIT = "usdunit"
    static let RMB_UNIT = "rmbunit"
}
