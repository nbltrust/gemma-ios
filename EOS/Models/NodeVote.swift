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
    var rate_at: CLongLong!
    var createdAt: CLongLong!
    var updatedAt: CLongLong!
}

