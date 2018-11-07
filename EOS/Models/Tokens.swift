//
//  Tokens.swift
//  EOS
//
//  Created by zhusongyu on 2018/11/6.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import HandyJSON

struct Tokens: HandyJSON {
    var balance: String!
    var totalValue: String!
    var owner: String!
    var price: String!
    var logoUrl: String!
    var contract: String!
    var symbol: String!
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<< self.totalValue <-- "total_value"
        mapper <<< self.logoUrl <-- "logo_url"
    }
}
