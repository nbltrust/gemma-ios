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
            Defaults["accountName\(id)"] = name
        }
    }

    func saveAccountNamesWith(_ currencyID: Int64?, accounts: [String]?) {
        if let id = currencyID {
            Defaults["accountNames\(id)"] = accounts
        }
    }

    func getAccountNameWith(_ currencyID: Int64?) -> String? {
        if let id = currencyID {
            if let name = Defaults["accountName\(id)"] as? String {
                return name
            }
        }
        return nil
    }

    func getAccountNamesWith(_ currencyID: Int64?) -> [String]? {
        if let id = currencyID {
            if let accounts = Defaults["accountNames\(id)"] as? [String] {
                return accounts
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

    func getCurrentCurrency() -> Currency? {
        do {
            if let currencyId = getCurrentCurrencyID() {
                return try WalletCacheService.shared.fetchCurrencyBy(id: currencyId)
            }
        } catch {}
        return nil
    }

    func getCurrentAccountName() -> String {
        if let name = getAccountNameWith(getCurrentCurrencyID()) {
            return name
        }
        return "--"
    }

    func getCurrentAccountNames() -> [String] {
        if let names = getAccountNamesWith(getCurrentCurrencyID()) {
            return names
        }
        return []
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


    func fetchAccount(_ type: CurrencyType , callback: @escaping CompletionCallback) {
        if type == .EOS {
            if let currency = getCurrentCurrency(), let pubKey = currency.pubKey {
                getEOSAccountNames(pubKey) { (result, accounNames) in
                    callback()
                }
            }
        }
    }

    func getEOSAccountNames(_ publicKey: String, completion: @escaping (_ result: Bool, _ accounts: [String]) -> Void) {
        EOSIONetwork.request(target: .getKeyAccounts(pubKey: publicKey), success: { (json) in
            if let names = json["account_names"].arrayObject as? [String] {
                completion(names.count > 0,names)
            }
        }, error: { (_) in
            completion(false,[])
        }) { (_) in
            completion(false,[])
        }
    }
}
