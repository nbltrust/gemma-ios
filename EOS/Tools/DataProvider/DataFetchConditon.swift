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
    case like = "LIKE"
    case not = "NOT"
    
    func desc() -> String {
        return " " + self.rawValue + " "
    }
}

enum SQLConditionReLation: String {
    case and = " AND "
    case or = " OR "
    func desc() -> String {
        return " " + self.rawValue + " "
    }
}

struct DataFetchCondition {
    var key: String!
    var value: String!
    var check: ValueCheckType!
}
