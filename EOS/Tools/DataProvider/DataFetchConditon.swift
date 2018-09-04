//
//  DataFetchConditon.swift
//  EOS
//
//  Created by peng zhu on 2018/9/3.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import Foundation

enum ValueCheckType: String {
    case equal = "="
    case greater = ">"
    case greaterAndEqual = ">="
    case less = "<"
    case lessAndEqual = "<="
    case like = "like"
}

struct DataFetchCondition {
    var key: String!
    var value: Any!
    var check: ValueCheckType!
}
