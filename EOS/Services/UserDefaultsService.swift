//
//  UserDefaultsService.swift
//  EOS
//
//  Created by koofrank on 2018/7/4.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

extension DefaultsKeys {
    static let language = DefaultsKey<String>("language")
    static let wallets = DefaultsKey<[String]>("wallets")
    static let currentWallet = DefaultsKey<String>("current-wallet")
    static let currentAccount = DefaultsKey<String>("current-account")
}
