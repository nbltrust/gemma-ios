//
//  NodeVote.swift
//  EOS
//
//  Created by peng zhu on 2018/8/9.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import HandyJSON

struct NodeVote: HandyJSON {
    var account: String!
    var alias: String!
    var votes: String!
    var url: String!
    var location: Int!
    var percentage: Float!
    var key: String!
    var priority: Int!
    var rateAt: Int64!
    var createdAt: Int64!
    var updatedAt: Int64!
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.rateAt <-- "rate_at"
    }
}
