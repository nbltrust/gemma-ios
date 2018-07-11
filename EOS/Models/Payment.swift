//
//  payment.swift
//  EOS
//
//  Created by koofrank on 2018/7/11.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import HandyJSON

enum PaymentStatus: Int {
    case unconfirmed = 1
    case confirming
    case confirmed
}

struct Payment:HandyJSON {
    var from:String!
    var to:String!
    var value:String! //1.0000 EOS
    var memo:String!
    var time:Date!
    var block:String!
    var hash:String!
    var status: PaymentStatus!
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<<
            time <-- GemmaDateFormatTransform(formatString: "yyyy-MM-dd'T'HH:mm:ss")
    }
    
    init() {}
}
