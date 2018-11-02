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
import seed39_ios_golang
import eos_ios_core_cpp

class CurrencyManager {
    static let shared = CurrencyManager()

    func getCipherPrikey() -> String? {
        if let id = getCurrentCurrencyID() {
            do {
                let currency = try WalletCacheService.shared.fetchCurrencyBy(id: id)
                return currency?.cipher
            } catch {
                return nil
            }
        }
        return nil
    }

    //验证密码
    func pwdIsCorrect(_ currencyID: Int64?, password: String) -> Bool {
        do {
            if let id = currencyID {
                let currency = try WalletCacheService.shared.fetchCurrencyBy(id: id)
                let prikey = EOSIO.getPirvateKey(currency?.cipher, password: password)
                if currency?.type == .EOS, EOSIO.getPublicKey(prikey) == currency?.pubKey {
                    return true
                } else if currency?.type == .ETH, Seed39GetEthereumAddressFromPrivateKey(prikey) == currency?.address {
                    return true
                }
                return false
            }
            return false
        } catch {
            return false
        }
    }

    func getCiperWith(_ currencyID: Int64?) -> String? {
        do {
            if let id = currencyID {
                let currency = try WalletCacheService.shared.fetchCurrencyBy(id: id)
                let wallet = try WalletCacheService.shared.fetchWalletBy(id: (currency?.wid)!)
                return wallet!.cipher
            }
            return nil
        } catch {
            return nil
        }
    }

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
    func saveBalanceJsonWith(_ account: String?, json: JSON) {
        if let account = account {
            Defaults["balanceJson\(account)"] = json.rawString()
        }
    }

    func saveAccountJsonWith(_ account: String?, json: JSON) {
        if let account = account {
            Defaults["accountJson\(account)"] = json.rawString()
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

    func getBalanceJsonWith(_ account: String?) -> JSON? {
        if let account = account {
            if let jsonStr = Defaults["balanceJson\(account)"] as? String, let json = JSON.init(parseJSON: jsonStr) as? JSON {
                return json
            }
        }
        return nil
    }

    func getAccountJsonWith(_ account: String?) -> JSON? {
        if let account = account {
            if let jsonStr = Defaults["accountJson\(account)"] as? String, let json = JSON.init(parseJSON: jsonStr) as? JSON {
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
