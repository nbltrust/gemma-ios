//
//  Utils.swift
//  EOS
//
//  Created by koofrank on 2018/7/9.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import SwifterSwift
import Guitar

extension String {
    var eosAmount: String {
        if self.contains(" ") {
            return self.components(separatedBy: " ").first ?? ""
        }
        else {
            return ""
        }
    }
    
    var hashNano: String {
        if let front = self.substring(from: 0, length: 8), let behind = self.substring(from: self.count - 9, length: 8) {
            return front + "..." + behind
        }
        
        return self
    }
}

extension Date {
    var refundStatus:String {
        let interval = self.addingTimeInterval(72 * 3600).timeIntervalSince(Date())
        let day = floor(interval / 86400)
        let hour = ceil((interval - day * 86400) / 3600)
        
        if day > 0 {
            return String.init(format: "%02.0f%@%02.0f%@", day, R.string.localizable.day(), hour, R.string.localizable.hour())
        }
        else {
            return ""
        }
    }
}

extension Int64 {
    var ramCount:String {
        return ByteCountFormatter.string(fromByteCount: self, countStyle: .file)
    }
}


func checkAccountName(_ sender : String) -> (success:Bool, error_info:String){
    if sender.count > 12{
        return (false,"账户最长12位")
    }
    
    let legal = Guitar(pattern: "([^a-z1-5])")
    if legal.test(string: sender){
        return (false,"账户必须是小写英文字母+1～5数字")
    }
    
    return (true,"")
}


func correctAmount(_ sender:String) -> String{
    if let _ = sender.toDouble(){
        if sender.contains("."),let last = sender.components(separatedBy: ".").last{
            if last.count > 4{
                return sender.components(separatedBy: ".").first! + last.substring(from: 0, length: 4)!
            }
            return sender
        }
    }
    return ""
}

func pushTransfer(){
    
//    EOSIOService.push_transaction(json: <#T##String#>)
}

