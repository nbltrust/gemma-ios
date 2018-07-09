//
//  Account.swift
//  EOS
//
//  Created by koofrank on 2018/7/9.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import HandyJSON

struct Account:HandyJSON {
    var account_name:String!
    var total_resources:TotalResource?
    var refund_request:ReFundRequest?
    
    init() {}
}

struct TotalResource:HandyJSON {
    var net_weight:String!
    var cpu_weight:String!
    var ram_bytes:Int64!

    init() {}
}


struct ReFundRequest:HandyJSON {
    var request_time:Date!
    var net_amount:String!
    var cpu_amount:String!
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<<
            request_time <-- GemmaDateFormatTransform(formatString: "yyyy-MM-dd'T'HH:mm:ss")
    }
    
    init() {}
}

open class GemmaDateFormatTransform: DateFormatterTransform {
    
    public init(formatString: String) {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        super.init(dateFormatter: formatter)
    }
}
