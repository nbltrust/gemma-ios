//
//  CurrencyManager.swift
//  EOS
//
//  Created by zhusongyu on 2018/10/31.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation
import SwiftyJSON
import SwiftyUserDefaults

class CurrencyManager {
    static let shared = CurrencyManager()


    //新版本存取币种信息
    func saveAccountNameWith(_ currencyID: Int64?, name: String?) {
        if let id = currencyID {
            Defaults["accountNames\(id)"] = name
        }
    }

    func getAccountNameWith(_ currencyID: Int64?) -> String? {
        if let id = currencyID {
            if let name = Defaults["accountNames\(id)"] as? String {
                return name
            }
        }
        return nil
    }

    func saveCurrentCurrencyID(_ currencyID: Int64?) {
        if let id = currencyID {
            Defaults["currencyID"] = id.string
        }
    }

    func getCurrentCurrencyID() -> Int64? {
        if let id = Defaults["currencyID"] as? String {
            return Int64(id)
        }
        return nil
    }


    //新版本存取缓存数据
    func saveBalanceJsonWith(_ currencyID: Int64?, json: JSON) {
        if let id = currencyID {
            Defaults["balanceJson\(id)"] = json.rawString()
        }
    }

    func saveAccountJsonWith(_ currencyID: Int64?, json: JSON) {
        if let id = currencyID {
            Defaults["accountJson\(id)"] = json.rawString()
        }
    }

    func savePriceJsonWith(_ currencyID: Int64?, json: [JSON]) {
        if let eos = json.filter({ $0["name"].stringValue == NetworkConfiguration.EOSIODefaultSymbol }).first {
            Defaults["cny"] = eos["value"].stringValue
        }
        if let usd = json.filter({ $0["name"].stringValue == NetworkConfiguration.USDTDefaultSymbol }).first {
            Defaults["usd"] = usd["value"].stringValue
        }
    }

    func getBalanceJsonWith(_ currencyID: Int64?) -> JSON? {
        if let id = currencyID {
            if let jsonStr = Defaults["balanceJson\(id)"] as? String, let json = JSON.init(parseJSON: jsonStr) as? JSON {
                return json
            }
        }
        return nil
    }

    func getAccountJsonWith(_ currencyID: Int64?) -> JSON? {
        if let id = currencyID {
            if let jsonStr = Defaults["accountJson\(id)"] as? String, let json = JSON.init(parseJSON: jsonStr) as? JSON {
                return json
            }
        }
        return nil
    }

    func getCNYPrice() -> String? {
        if let cny = Defaults["cny"] as? String {
            return cny
        }
        return nil
    }

    func getUSDPrice() -> String? {
        if let usd = Defaults["usd"] as? String {
            return usd
        }
        return nil
    }
}
