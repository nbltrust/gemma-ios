//
//  NodeVote.swift
//  EOS
//
//  Created by peng zhu on 2018/8/9.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import HandyJSON

struct NodeVoteData: HandyJSON {
    var rows: [NodeVote]!
    var total_producer_vote_weight: String!
}

struct NodeVote: HandyJSON {
    var unpaid_blocks: Int!
    var producer_key: String!
    var location: Int!
    var last_claim_time: CLongLong!
    var is_active: Int!
    var owner: String!
    var url: String!
    var total_votes: String!
}

