//
//  EOSIOTableRow.swift
//  EOS
//
//  Created by koofrank on 2018/8/9.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import Foundation
import HandyJSON

struct TableProducers: HandyJSON {
    var scope: String = EOSIOContract.EOSIO_CODE
    var code: String = EOSIOContract.EOSIO_CODE
    var table: String = EOSIOTable.producers.rawValue
    var json: Bool = true
    var limit: Int = 20
}
