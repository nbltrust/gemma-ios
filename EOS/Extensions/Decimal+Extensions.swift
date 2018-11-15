//
//  Decimal+Extensions.swift
//  EOS
//
//  Created by koofrank on 2018/7/11.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation

extension Decimal { // 解决double 计算精度丢失
    var stringValue:String {
        return NSDecimalNumber(decimal: self).stringValue
    }

    var doubleValue:Double {
        let str = self.stringValue

        if let double = Double(str) {
            return double
        }
        return 0
    }

    func tradePrice() -> (price:String, pricision:Int) {
        var pricision = 0
        if self < Decimal(floatLiteral: 0.0001) {
            pricision = 8
        }
        else if self < Decimal(floatLiteral: 1) {
            pricision = 6
        }
        else {
            pricision = 4
        }

        return (self.string(digits: pricision), pricision)
    }

    func string(digits:Int = 0, roundingMode: NSDecimalNumber.RoundingMode = .plain) -> String {
        var decimal = self
        var drounded = Decimal()
        NSDecimalRound(&drounded, &decimal, digits, roundingMode)

        if digits == 0 {
            return drounded.stringValue
        }

        var formatterString : String = "0."

        for _ in 0 ..< digits {
            formatterString.append("0")
        }

        let formatter = NumberFormatter()
        formatter.positiveFormat = formatterString

        return formatter.string(from: NSDecimalNumber(decimal: drounded)) ?? "0"
    }
}
