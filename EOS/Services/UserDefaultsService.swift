//
//  UserDefaultsService.swift
//  EOS
//
//  Created by koofrank on 2018/7/4.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

enum WalletCreatStatus: Int {
    case willGetAccountInfo = 1
    case failedGetAccountInfo
    case failedWithReName
    case willGetLibInfo
    case creatSuccessed
}

struct WalletList: Codable, DefaultsSerializable {
    var name: String?
    var accountName: String?
    var created: String?
    var publicKey: String?
    var isBackUp: Bool?
    var creatStatus: Int?
    var getAccountInfoDate: Date?
    var isImport: Bool?
    var type: CreateAPPId?
    var deviceName: String?
}

extension WalletList: DefaultsDefaultArrayValueType {
    static let defaultArrayValue: [WalletList] = []
}

extension DefaultsKeys {
    static let currentWalletID = DefaultsKey<String>("current-wallet-id")//id

    //通用Setting
    static let language = DefaultsKey<String>("language")            //当前语言
    static let currentEOSURLNode = DefaultsKey<Int>("currentEOSURLNode")//当前EOS主网节点
    static let coinUnit = DefaultsKey<Int>("coinUnit")           //货币单位

    //安全设置
    static let gestureLockLockedTime = DefaultsKey<Int>("gestureLockLockedTime")
    static let isFaceIDOpened = DefaultsKey<Bool>("isFaceIDOpened")
    static let isGestureLockOpened = DefaultsKey<Bool>("isGestureLockOpened")
    static let gestureLockPassword = DefaultsKey<String>("gestureLockPassword")
    static let isFingerPrinterLockOpened = DefaultsKey<Bool>("isFingerPrinterLockOpened")

    //网络
    static let NetworkReachability = DefaultsKey<String>("NetworkReachability")//网络
}
