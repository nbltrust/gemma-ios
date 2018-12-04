//
//  Order.swift
//  EOS
//
//  Created by zhusongyu on 2018/9/17.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import Foundation
import HandyJSON

struct Order: HandyJSON {
    var id: String!
    var cpu: String!
    var net: String!
    var ram: String!
    var rmbPrice: String!

    mutating func mapping(mapper: HelpingMapper) {
        mapper <<< self.id <-- "_id"
        mapper <<< self.rmbPrice <-- "rmb_price"
    }
}

struct Bill: HandyJSON {
    var cpu: String!
    var net: String!
    var ram: String!
    var rmbPrice: String!
}

struct Place: HandyJSON {
    var appid: String!
    var partnerid: String!
    var nonceStr: String!
    var sign: String!
    var prepayid: String!
    var timestamp: String!
    var actionId: String!

    mutating func mapping(mapper: HelpingMapper) {
        mapper <<< self.actionId <-- "action_id"
    }
}
