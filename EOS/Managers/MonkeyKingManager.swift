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
    
    func wechatPay(resultCallback: @escaping ResultCallback) {
        let session = URLSession.shared
        
        let datatask = session.dataTask(with: URL(string: "http://www.example.com/pay.php?payType=weixin")!) { (data, urlResponse, error) in
            if data != nil {
                let urlString = String(data: data!, encoding: .utf8)!
                let order = MonkeyKing.Order.weChat(urlString: urlString)
                MonkeyKing.deliver(order) { result in
                    print("result: \(result)")
                    resultCallback(result)
                }
            } else {
                if let error = error {
                    print(error)
                    resultCallback(false)
                }
            }
        }
        
        print(datatask.accessibilityActivate())
        if datatask.accessibilityActivate() == false {
            resultCallback(false)
        }
    }
}
