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
    var account_name: String!
    var total_resources: TotalResource?
    var self_delegated_bandwidth: DelegatedBandWidth?
    var refund_request: ReFundRequest?
    var net_limit: NetLimit?
    var cpu_limit: CpuLimit?
    var ram_quota: Int64!
    var ram_usage: Int64!
    var created: String!
    var permissions: [Permission]!

    init() {}
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
    var required_auth: RequiredAuth!
    var parent: String!
    var perm_name: String!
    init() {}
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
    var net_weight: String!
    var cpu_weight: String!
    var ram_bytes: Int64!

    init() {}
}

struct ReFundRequest: HandyJSON {
    var request_time: Date!
    var net_amount: String!
    var cpu_amount: String!

    mutating func mapping(mapper: HelpingMapper) {
        mapper <<<
            request_time <-- GemmaDateFormatTransform(formatString: "yyyy-MM-dd'T'HH:mm:ss")
    }

    init() {}
}

struct DelegatedBandWidth: HandyJSON {
    var from: String!
    var to: String!
    var net_weight: String!
    var cpu_weight: String!

    init() {}
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
        accountModel.account_name = self.account_name
        accountModel.net_weight = self.total_resources?.net_weight
        accountModel.cpu_weight = self.total_resources?.cpu_weight
        accountModel.ram_bytes = self.total_resources?.ram_bytes
        accountModel.from = self.self_delegated_bandwidth?.from
        accountModel.to = self.self_delegated_bandwidth?.to
        accountModel.delegate_net_weight = self.self_delegated_bandwidth?.net_weight
        accountModel.delegate_cpu_weight = self.self_delegated_bandwidth?.cpu_weight
        accountModel.request_time = self.refund_request?.request_time
        accountModel.net_amount = self.refund_request?.net_amount
        accountModel.cpu_amount = self.refund_request?.cpu_amount
        accountModel.net_used = self.net_limit?.used
        accountModel.net_available = self.net_limit?.available
        accountModel.net_max = self.net_limit?.max
        accountModel.cpu_used = self.cpu_limit?.used
        accountModel.cpu_available = self.cpu_limit?.available
        accountModel.cpu_max = self.cpu_limit?.max
        accountModel.ram_quota = self.ram_quota
        accountModel.ram_usage = self.ram_usage
        accountModel.created = self.created

        return accountModel
    }
}
