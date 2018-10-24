//
//  payment.swift
//  EOS
//
//  Created by koofrank on 2018/7/11.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import HandyJSON

enum PaymentStatus: Int, HandyJSONEnum {
    case unconfirmed = 1
    case confirming
    case confirmed
    case fail

    func description() -> String {
        switch self {
        case .unconfirmed:
            return R.string.localizable.trade_unensure.key.localized()
        case .confirming:
            return R.string.localizable.trade_ensuring.key.localized()
        case .confirmed:
            return R.string.localizable.trade_ensure.key.localized()
        case .fail:
            return R.string.localizable.trade_failed.key.localized()
        }
    }
}

struct Payment: HandyJSON {
    var from: String!
    var to: String!
    var value: String! //1.0000 EOS
    var memo: String!
    var time: Date!
    var block: Int!
    var hash: String!
    var status: PaymentStatus!

    mutating func mapping(mapper: HelpingMapper) {
        mapper <<<
            time <-- GemmaDateFormatTransform(formatString: "yyyy-MM-dd'T'HH:mm:ss.zzz")
    }

    init() {}
}
