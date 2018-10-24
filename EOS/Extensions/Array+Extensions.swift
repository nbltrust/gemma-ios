//
//  Array+Extensions.swift
//  EOS
//
//  Created by peng zhu on 2018/10/16.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation

extension Array {
    func sortJsonString() -> String {
        let array = self
        var arr: Array<String> = []
        var signString = "["
        for value in array {
            if let value = value as? Dictionary<String, Any> {//Dictionary 递归
                arr.append(value.sortJsonString())
            } else if let value = value as? Array<Any> {//Array 递归
                arr.append(value.sortJsonString())
            } else {//其他 直接拼接
                arr.append("\"\(value)\"")
            }
        }
        arr.sort { $0 < $1 }
        signString += arr.joined(separator: ",")
        signString += "]"
        return signString
    }
}
