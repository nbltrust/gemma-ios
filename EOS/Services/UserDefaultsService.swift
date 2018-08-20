//
//  UserDefaultsService.swift
//  EOS
//
//  Created by koofrank on 2018/7/4.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

struct WalletList: Codable, DefaultsSerializable {
    var name: String
    var publicKey: String
    var accountIndex: Int
    var isBackUp: Bool
    var isConfirmLib: Bool
    var txId: String?
    var invitationCode:String?
    var isImport: Bool?
}

extension WalletList: DefaultsDefaultArrayValueType {
    static let defaultArrayValue: [WalletList] = []
}

extension DefaultsKeys {
    static let language = DefaultsKey<String>("language")
    static let walletList = DefaultsKey<[WalletList]>("walletLists")
    static let currentWallet = DefaultsKey<String>("current-wallet")//公钥
    //安全设置
    static let gestureLockLockedTime = DefaultsKey<Int>("gestureLockLockedTime")
    static let isFaceIDOpened = DefaultsKey<Bool>("isFaceIDOpened")
    static let isGestureLockOpened = DefaultsKey<Bool>("isGestureLockOpened")
    static let gestureLockPassword = DefaultsKey<String>("gestureLockPassword")
    static let isFingerPrinterLockOpened = DefaultsKey<Bool>("isFingerPrinterLockOpened")
}
