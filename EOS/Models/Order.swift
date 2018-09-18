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
    var _id: String!
}

struct Bill: HandyJSON {
    var cpu: String!
    var net: String!
    var ram: String!
    var rmbPrice: String!
}

struct Place: HandyJSON {
    var return_code: String!
    var appid: String!
    var mch_id: String!
    var nonce_str: String!
    var sign: String!
    var prepay_id: String!
}
