//
//  Decimal+Extensions.swift
//  EOS
//
//  Created by koofrank on 2018/7/11.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation

extension Decimal { // 解决double 计算精度丢失
    var stringValue: String {
        return NSDecimalNumber(decimal: self).stringValue
    }

    var doubleValue: Double {
        let str = self.stringValue

        if let d = Double(str) {
            return d
        }
        return 0
    }
}
