//
//  File.swift
//  EOS
//
//  Created by zhusongyu on 2018/12/4.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import HandyJSON

struct Actions: HandyJSON {
    var status: String!
    var blockNum: Int64!
    var headBlock: Int64!
    var lastIrreversibleBlock: Int64!
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<< self.blockNum <-- "block_num"
        mapper <<< self.headBlock <-- "head_block"
        mapper <<< self.lastIrreversibleBlock <-- "last_irreversible_block"
    }
}

struct Goodscode: HandyJSON {
    var rights: Rights!
}

struct Rights: HandyJSON {
    var delegation: DelegateActions!
}

struct DelegateActions: HandyJSON {
    var actions: [String]!
}
