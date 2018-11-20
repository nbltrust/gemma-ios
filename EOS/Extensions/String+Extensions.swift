//
//  String+Extensions.swift
//  EOS
//
//  Created by koofrank on 2018/7/11.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation

extension String {
    static var numberFormatters:[NumberFormatter] = []
    static var doubleFormat:NumberFormatter = NumberFormatter()

    var filterJade:String {
        return self.replacingOccurrences(of: "JADE.", with: "")
    }

    var getID:Int32 {
        if self == "" {
            return 0
        }

        if let id = self.components(separatedBy: ".").last {
            return Int32(id)!
        }

        return 0
    }

    var tradePrice:(price:String, pricision:Int ,amountPricision : Int) {//0.0001  1   8 6 4
        if let oldPrice = self.toDouble() {
            return oldPrice.tradePrice()
        }

        return (self, 0 , 0)
    }

    public func toDouble() -> Double? {
        if self == "" {
            return 0
        }

        var selfString = self
        if selfString.contains(","){
            selfString = selfString.replacingOccurrences( of:"[^0-9.]", with: "", options: .regularExpression)
        }

        return Double(selfString)
    }


    public func toDecimal() -> Decimal? {
        if self == "" {
            return Decimal(0)
        }
        var selfString = self
        if selfString.contains(","){
            selfString = selfString.replacingOccurrences( of:"[^0-9.]", with: "", options: .regularExpression)
        }
        return Decimal(string:selfString)
    }


    func formatCurrency(digitNum: Int) -> String {

        if let str = toDouble()?.formatCurrency(digitNum: digitNum) {
            return str
        }
        return ""
    }

    func suffixNumber(digitNum: Int = 5) -> String {
        if let str = Double(self)?.suffixNumber(digitNum:digitNum) {
            return str
        }
        return ""
    }
}
