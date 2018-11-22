//
//  BLTCardConfirmPinActions.swift
//  EOS
//
//  Created peng zhu on 2018/9/13.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import Foundation
import ReSwift
import RxCocoa
import SwiftyJSON
import HandyJSON

enum ConfirmPinType: Int,Codable {
    case verifyPin = 0
    case transferWithPin
}

struct BLTCardConfirmPinContext: RouteContext, HandyJSON {
    var publicKey = WalletManager.shared.currentPubKey
    var iconType = ""
    var producers: [String] = []
    var type = ""
    var receiver = ""
    var amount = ""
    var remark = ""
    var confirmType: ConfirmPinType = .verifyPin
    var confirmSuccessed: CompletionCallback?
}

// MARK: - State
struct BLTCardConfirmPinState: BaseState {
    var context: BehaviorRelay<RouteContext?> = BehaviorRelay(value: nil)

    var pageState: BehaviorRelay<PageState> = BehaviorRelay(value: .initial)
}

// MARK: - Action
struct BLTCardConfirmPinFetchedAction: Action {
    var data: JSON
}
