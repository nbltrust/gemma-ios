//
//  Dictionary+Extensions.swift
//  EOS
//
//  Created by peng zhu on 2018/10/16.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation

extension Dictionary {
    func sortJsonString() -> String {
        var tempDic = self as! Dictionary<String, Any>
        var keys = Array<String>()
        for key in tempDic.keys {
            keys.append(key)
        }
        keys.sort { $0 < $1 }
        var signString = "{"
        var arr: Array<String> = []
        for key in keys {
            let value = tempDic[key]
            if let value = value as? Dictionary<String, Any> {//Dictionary 递归
                arr.append("\"\(key)\":\(value.sortJsonString())")
            } else if let value = value as? Array<Any> {//Array 递归
                arr.append("\"\(key)\":\(value.sortJsonString())")
            } else {//其他 直接拼接
                let value = tempDic[key]

                if value is Int {
                    arr.append("\"\(key)\":\(value!)")
                } else {
                    arr.append("\"\(key)\":\"\(value!)\"")
                }
            }
        }
        signString += arr.joined(separator: ",")
        signString += "}"
        return signString
    }
}
