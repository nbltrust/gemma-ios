//
//  Account.swift
//  EOS
//
//  Created by koofrank on 2018/7/9.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import HandyJSON

struct Account: HandyJSON {
    var accountName: String!
    var totalResources: TotalResource?
    var selfDelegatedBandwidth: DelegatedBandWidth?
    var refundRequest: ReFundRequest?
    var netLimit: NetLimit?
    var cpuLimit: CpuLimit?
    var ramQuota: Int64!
    var ramUsage: Int64!
    var created: String!
    var permissions: [Permission]!

    init() {}

    mutating func mapping(mapper: HelpingMapper) {
        mapper <<< self.accountName <-- "account_name"
        mapper <<< self.totalResources <-- "total_resources"
        mapper <<< self.selfDelegatedBandwidth <-- "self_delegated_bandwidth"
        mapper <<< self.refundRequest <-- "refund_request"
        mapper <<< self.netLimit <-- "net_limit"
        mapper <<< self.cpuLimit <-- "cpu_limit"
        mapper <<< self.ramQuota <-- "ram_quota"
        mapper <<< self.ramUsage <-- "ram_usage"
    }

}

struct NetLimit: HandyJSON {
    var used: Int64!
    var available: Int64!
    var max: Int64!

    init() {}
}

struct CpuLimit: HandyJSON {
    var used: Int64!
    var available: Int64!
    var max: Int64!

    init() {}
}

struct Permission: HandyJSON {
    var requiredAuth: RequiredAuth!
    var parent: String!
    var permName: String!
    init() {}

    mutating func mapping(mapper: HelpingMapper) {
        mapper <<< self.requiredAuth <-- "required_auth"
        mapper <<< self.permName <-- "perm_name"
    }

}

struct RequiredAuth: HandyJSON {
    var threshold: Int64!
    var waits: [ReAuthWait]!
    var accounts: [ReAuthAccounts]!
    var keys: [ReAuthKey]!
    init() {}
}

struct ReAuthWait: HandyJSON {

}

struct ReAuthAccounts: HandyJSON {

}

struct ReAuthKey: HandyJSON {
    var key: String!
    var weight: Int64!
    init() {}
}

struct TotalResource: HandyJSON {
    var netWeight: String!
    var cpuWeight: String!
    var ramBytes: Int64!

    init() {}

    mutating func mapping(mapper: HelpingMapper) {
        mapper <<< self.netWeight <-- "net_weight"
        mapper <<< self.cpuWeight <-- "cpu_weight"
        mapper <<< self.ramBytes <-- "ram_bytes"
    }
}

struct ReFundRequest: HandyJSON {
    var requestTime: Date!
    var netAmount: String!
    var cpuAmount: String!

    mutating func mapping(mapper: HelpingMapper) {
        mapper <<<
            requestTime <-- ("request_time", GemmaDateFormatTransform(formatString: "yyyy-MM-dd'T'HH:mm:ss"))
        mapper <<< self.netAmount <-- "net_amount"
        mapper <<< self.cpuAmount <-- "cpu_amount"

    }

    init() {}
}

struct DelegatedBandWidth: HandyJSON {
    var from: String!
    var to: String!
    var netWeight: String!
    var cpuWeight: String!

    init() {}

    mutating func mapping(mapper: HelpingMapper) {
        mapper <<< self.netWeight <-- "net_weight"
        mapper <<< self.cpuWeight <-- "cpu_weight"
    }
}

struct Valid: HandyJSON {
    var valid: Bool!

    init() {}
}

open class GemmaDateFormatTransform: DateFormatterTransform {

    public init(formatString: String) {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = formatString

        super.init(dateFormatter: formatter)
    }
}

extension Account {
    func toAccountModel() -> AccountModel {
        var accountModel = AccountModel()
        accountModel.accountName = self.accountName
        accountModel.netWeight = self.totalResources?.netWeight
        accountModel.cpuWeight = self.totalResources?.cpuWeight
        accountModel.ramBytes = self.totalResources?.ramBytes
        accountModel.from = self.selfDelegatedBandwidth?.from
        accountModel.to = self.selfDelegatedBandwidth?.to
        accountModel.delegateNetWeight = self.selfDelegatedBandwidth?.netWeight
        accountModel.delegateCpuWeight = self.selfDelegatedBandwidth?.cpuWeight
        accountModel.requestTime = self.refundRequest?.requestTime
        accountModel.netAmount = self.refundRequest?.netAmount
        accountModel.cpuAmount = self.refundRequest?.cpuAmount
        accountModel.netUsed = self.netLimit?.used
        accountModel.netAvailable = self.netLimit?.available
        accountModel.netMax = self.netLimit?.max
        accountModel.cpuUsed = self.cpuLimit?.used
        accountModel.cpuAvailable = self.cpuLimit?.available
        accountModel.cpuMax = self.cpuLimit?.max
        accountModel.ramQuota = self.ramQuota
        accountModel.ramUsage = self.ramUsage
        accountModel.created = self.created

        return accountModel
    }
}
