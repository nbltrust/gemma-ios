//
//  AccountModel.swift
//  EOS
//
//  Created by zhusongyu on 2018/10/6.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation

struct AccountModel: DBProtocol {
    var account_name: String! = ""

//    var balance: String! = "- \(NetworkConfiguration.EOSIO_DEFAULT_SYMBOL)"
//    var cny: String! = ""
//    var usd: String! = ""

    //    var price: Decimal! = 0

    var net_weight: String! = ""
    var cpu_weight: String! = ""
    var ram_bytes: Int64! = 0

    var from: String! = ""
    var to: String! = ""
    var delegate_net_weight: String! = ""
    var delegate_cpu_weight: String! = ""

    var request_time: Date! = Date.init()
    var net_amount: String! = ""
    var cpu_amount: String! = ""

    var net_used: Int64! = 0
    var net_available: Int64! = 0
    var net_max: Int64! = 0

    var cpu_used: Int64! = 0
    var cpu_available: Int64! = 0
    var cpu_max: Int64! = 0

    var ram_quota: Int64! = 0
    var ram_usage: Int64! = 0
    var created: String! = ""

    var parent: String! = ""
    var perm_name: String! = ""

    var threshold: Int64! = 0

    var key: String! = ""
    var weight: Int64! = 0
}

extension DBProtocol where Self == AccountModel {
    mutating func primaryKey() -> String? {
        return "account_name"
    }

    mutating func whiteList() -> [String]? {
        return []
    }

    mutating func blackList() -> [String]? {
        return []
    }

    mutating func extensionColumns() -> [String: ParameterType]? {
        return nil
    }
}

extension AccountModel {
    mutating func saveToLocal() {
        //            var condition = DataFetchCondition()
        //            condition.key = "account_name"
        //            condition.value = WalletManager.shared.getAccount()
        //            condition.check = .equal

        self.save()
    }
}
