//
//  FingerManager.swift
//  EOS
//
//  Created by peng zhu on 2018/11/6.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation
import SwiftyJSON
import SwiftyUserDefaults

class FingerManager {
    static let shared = FingerManager()

    func updateFingerName(_ model: WalletManagerModel, index: Int, fingerName: String) {
        Defaults[fingerKey(model, index: index)] = fingerName
    }

    func deleteFingerName(_ model: WalletManagerModel, index: Int) {
        updateFingerName(model, index: index, fingerName: "")
    }

    func fingerKey(_ model: WalletManagerModel, index: Int) -> String {
        return model.address + "\(index)"
    }

    func fingerName(_ model: WalletManagerModel, index: Int) -> String {
        if let name: String = Defaults[fingerKey(model, index: index)] as? String, !name.isEmpty {
            return name
        } else {
            return R.string.localizable.finger.key.localized() + fingerIndexStr(index)
        }
    }

    func fingerIndexStr(_ index: Int) -> String {
        switch index {
        case 0:
            return "一"
        case 1:
            return "二"
        case 2:
            return "三"
        default:
            return ""
        }
    }
}
