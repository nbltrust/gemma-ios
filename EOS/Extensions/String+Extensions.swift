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
