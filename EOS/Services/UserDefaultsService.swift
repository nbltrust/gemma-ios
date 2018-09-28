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

enum WalletType: Int,Decodable,Encodable {
    case custom = 1
    case bluetooth
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
//    var type: WalletType?
//    var deviceName: String?
//    var bluetooth: BLTDevice?
}

extension WalletList: DefaultsDefaultArrayValueType {
    static let defaultArrayValue: [WalletList] = []
}

extension DefaultsKeys {
    static let walletList = DefaultsKey<[WalletList]>("walletLists")
    static let currentWallet = DefaultsKey<String>("current-wallet")//公钥
    
    //通用Setting
    static let language = DefaultsKey<String>("language")            //当前语言
    static let currentURLNode = DefaultsKey<Int>("currentURLNode")//当前EOS主网节点
    static let coinUnit = DefaultsKey<Int>("coinUnit")           //货币单位
    
    //安全设置
    static let gestureLockLockedTime = DefaultsKey<Int>("gestureLockLockedTime")
    static let isFaceIDOpened = DefaultsKey<Bool>("isFaceIDOpened")
    static let isGestureLockOpened = DefaultsKey<Bool>("isGestureLockOpened")
    static let gestureLockPassword = DefaultsKey<String>("gestureLockPassword")
    static let isFingerPrinterLockOpened = DefaultsKey<Bool>("isFingerPrinterLockOpened")
}
