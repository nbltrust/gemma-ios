//
//  MonkeyKingManager.swift
//  EOS
//
//  Created by zhusongyu on 2018/9/5.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//
import UIKit

import Foundation
import MonkeyKing

class MonkeyKingManager {
    static let shared = MonkeyKingManager()
    func wechatPay(urlString: String, resultCallback: @escaping ResultCallback) {
        let order = MonkeyKing.Order.weChat(urlString: urlString)
        MonkeyKing.deliver(order) { result in
            print("result: \(result)")
            resultCallback(result)
        }
    }
}
