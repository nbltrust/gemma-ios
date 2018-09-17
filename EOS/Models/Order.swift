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
    var cpu: String!
    var net: String!
    var ram: String!
    var rmb_price: String!

}
