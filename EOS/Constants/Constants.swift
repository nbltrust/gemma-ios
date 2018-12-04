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
typealias HandleResult = (Bool, String) -> Void

var appCoodinator: AppCoordinator {
    return AppConfiguration.shared.appCoordinator
}

struct AppConfiguration {
    static let APPID = ""

    static let EOSPrecision = 4

    static let EOSErrorCodeBase = "eos_errorcode_"

    static let shared = AppConfiguration()
    var appCoordinator: AppCoordinator!

    private init() {
        let rootVC = BaseNavigationController()
        appCoordinator = AppCoordinator(rootVC: rootVC)
    }
}

struct NetworkConfiguration {
    static let NBLBaseURL = URL(string: "https://faucet-eos-wookong.nbltrust.com")!

    static let NBLBaseStageURL = URL(string: "https://faucetstaging-eos-wookong.nbltrust.com")!

    static let NBLBaseTestURL = URL(string: "https://faucetdev-eos-wookong.nbltrust.com")!

    static let EOSIOBaseTestURL = URL(string: "http://139.224.135.236:18888")!//URL(string: "http://172.20.5.25:9999")!
    static let EOSIOCanadaTestURL = URL(string: "http://mainnet.eoscanada.com")!
    var EOSIOBaseURL: URL {
        get {
            var index = Defaults[.currentURLNode]
            let urls = EOSBaseURLNodesConfiguration.values
            if index < 0 || index >= urls.count {
                index = 0
            }
            return URL(string: urls[index])!
        }
    }
    var EOSIOOtherBaseURL: URL {
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
    static let EOSBPURL = URL(string: "https://eosweb.net")!

    static let EOSIODefaultSymbol = "EOS"
    static let USDTDefaultSymbol = "USDT"
    static let BlanceDefaultSymbol = "balance"
    static let RAMPriceDefaultSymbol = "ramprice"

    static let EOSFlareBaseURLString = "https://eosflare.io/tx/"

    static let ServerBaseURLString = "https://app.cybex.io/"
    static let ETHPrice = ServerBaseURLString + "price"
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
        "http://139.196.73.117:8888",
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
    static let TokenCode = "eosio.token"
    static let EOSIOCode = "eosio"
    static let EOSIOSystemCode = "eosio.system"
}

struct H5AddressConfiguration {
    static let GetInviteCodeURL = URL(string: "https://nebuladownload.oss-cn-beijing.aliyuncs.com/gemma/gemma_policy_cn.html")
    static let RegisterProtocolURL = URL(string: "https://nebuladownload.oss-cn-beijing.aliyuncs.com/gemma/gemma_policy_cn.html")
    static let HelpCNURL = URL(string: "https://cdn.nbltrust.com/gemma/gemma_policy_cn.html")
    static let HelpENURL = URL(string: "https://cdn.nbltrust.com/gemma/gemma_policy_en.html")
    static let ReleaseNotesCNURL = URL(string: "https://cdn.nbltrust.com/gemma/gemma_release_desc_cn.html")
    static let ReleaseNotesENURL = URL(string: "https://cdn.nbltrust.com/gemma/gemma_release_desc_en.html")
    static let FeedbackCNURL = URL(string: "http://47.75.154.39:3009/gemma?lang=cn")
    static let FeedbackENURL = URL(string: "http://47.75.154.39:3009/gemma?lang=en")
    static let DAppSinUpEOS = "https://mp.weixin.qq.com/s/wvrlzbj3EGv78s3gjoCvjw"
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
    static let USDUnit = "usdunit"
    static let RMBUnit = "rmbunit"
}

struct SupportCurrency {
    static let data: [CurrencyType] = [CurrencyType.EOS,CurrencyType.ETH]
}

struct BLTSupportCurrency {
    static let data: [CurrencyType] = [CurrencyType.EOS,CurrencyType.ETH]
}
