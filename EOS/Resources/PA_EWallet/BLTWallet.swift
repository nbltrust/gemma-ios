//
//  BLTWallet.swift
//  EOS
//
//  Created by peng zhu on 2018/9/14.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import Foundation

struct BLTWallet {
    var name: String?
    var nRSSI: Int?
    var nState: Int?
}

typealias walletDidSearch = (_ name: String,_ nRSSI: Int,_ nState: Int) -> Int

typealias walletDidDisconnected = (_ status: Int,_ des: String) -> Int

typealias walletBatteryCallback = (_ nBatterySource: Int,_ nBatteryState: Int) -> Int

