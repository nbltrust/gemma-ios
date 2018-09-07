//
//  Mirror+Extension.swift
//  EOS
//
//  Created by peng zhu on 2018/9/6.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import Foundation

enum ParameterType: Int {
    case int = 0
    case int8
    case int16
    case int32
    case int64
    case float
    case double
    case string
    case data
    case date
    case bool
    case unSupport
}

extension Mirror {
    func className() -> String {
        return String(describing: self.subjectType)
    }
    
    func dataStructure() -> [String : ParameterType] {
        var desc: [String : ParameterType] = [:]
        for child in self.children {
            if let label = child.label {
                let type = parameterType(child.value)
                if type != .unSupport {
                    desc[label] = parameterType(child.value)
                } else {
                    print("UnSuopprt Value Type for sqlite")
                }
            }
        }
        return desc
    }
    
    func parameterType(_ value: Any) -> ParameterType {
        switch value {
        case _ as Int:
            return .int
        case _ as Int8:
            return .int8
        case _ as Int16:
            return .int16
        case _ as Int32:
            return .int32
        case _ as Int64:
            return .int64
        case _ as Float:
            return .float
        case _ as Double:
            return .double
        case _ as String:
            return .string
        case _ as Data:
            return .data
        case _ as Date:
            return .date
        case _ as Bool:
            return .bool
        default:
            return .unSupport
        }
    }
}
