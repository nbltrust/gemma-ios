//
//  EOSIOTableRow.swift
//  EOS
//
//  Created by koofrank on 2018/8/9.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import Foundation
import HandyJSON

struct TableProducers:HandyJSON {
    var scope = EOSIOContract.EOSIO_CODE
    var code = EOSIOContract.EOSIO_CODE
    var table = EOSIOTable.producers
    var json = true
    var limit = 20
}
