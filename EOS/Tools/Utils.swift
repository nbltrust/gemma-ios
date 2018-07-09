//
//  Utils.swift
//  EOS
//
//  Created by koofrank on 2018/7/9.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import SwifterSwift

extension String {
    var eosAmount: String {
        if self.contains(" ") {
            return self.components(separatedBy: " ").first ?? ""
        }
        else {
            return ""
        }
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
