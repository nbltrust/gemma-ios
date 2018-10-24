//
//  Double+Extensions.swift
//  EOS
//
//  Created by koofrank on 2018/7/11.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation

extension Double {
    func string(digits: Int = 0) -> String {//会四舍五入
        if digits == 0 {
            return "\(self)"
        }

        let mul = pow(10, digits.double)

        let floornum = Foundation.floor(self * mul) / mul

        return String(format: "%.\(digits)f", floornum)
    }

    func preciseString() -> String {//解决显示科学计数法的格式
        let decimal = Decimal(floatLiteral: self)

        return decimal.stringValue
    }

    func suffixNumber(digitNum: Int = 5) -> String {
        var num = self
        let sign = ((num < 0) ? "-" : "")
        num = fabs(num)
        if (num < 1000.0) {
            return "\(sign)\(num.string(digits: digitNum))"
        }

        let exp: Int = Int(log10(num) / 3.0)
        let units: [String] = ["k", "m", "b"]

        let precision = pow(1000.0, exp.double)
        num = 100 * num / precision

        let result = num.rounded() / 100.0

        return "\(sign)\(result.string(digits: 2))" + "\(units[exp - 1])"
    }

    func formatCurrency(digitNum: Int, usesGroupingSeparator: Bool = true) -> String {
        if self < 1000 {
            return string(digits: digitNum)
        }

        let existFormatters = String.numberFormatters.filter({ (formatter) -> Bool in
            return formatter.maximumFractionDigits == digitNum && formatter.usesGroupingSeparator == usesGroupingSeparator
        })

        if let format = existFormatters.first {
            let result = format.string(from: NSNumber(value: self))
            return result!
        } else {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .currency
            numberFormatter.currencySymbol = ""
            numberFormatter.usesGroupingSeparator = usesGroupingSeparator
            numberFormatter.maximumFractionDigits = digitNum
            numberFormatter.minimumFractionDigits = digitNum
            String.numberFormatters.append(numberFormatter)
            return self.formatCurrency(digitNum: digitNum)
        }
    }
}
