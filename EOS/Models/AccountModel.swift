//
//  AccountModel.swift
//  EOS
//
//  Created by zhusongyu on 2018/10/6.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation

struct AccountModel: DBProtocol {
    var accountName: String! = ""

//    var balance: String! = "- \(NetworkConfiguration.EOSIO_DEFAULT_SYMBOL)"
//    var cny: String! = ""
//    var usd: String! = ""

    //    var price: Decimal! = 0

    var netWeight: String! = ""
    var cpuWeight: String! = ""
    var ramBytes: Int64! = 0

    var from: String! = ""
    var to: String! = ""
    var delegateNetWeight: String! = ""
    var delegateCpuWeight: String! = ""

    var requestTime: Date! = Date.init()
    var netAmount: String! = ""
    var cpuAmount: String! = ""

    var netUsed: Int64! = 0
    var netAvailable: Int64! = 0
    var netMax: Int64! = 0

    var cpuUsed: Int64! = 0
    var cpuAvailable: Int64! = 0
    var cpuMax: Int64! = 0

    var ramQuota: Int64! = 0
    var ramUsage: Int64! = 0
    var created: String! = ""

    var parent: String! = ""
    var permName: String! = ""

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
