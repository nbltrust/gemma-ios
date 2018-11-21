//
//  PayToActivateActions.swift
//  EOS
//
//  Created zhusongyu on 2018/9/6.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import Foundation
import ReSwift
import RxCocoa
import SwiftyJSON

// MARK: - State
struct PayToActivateState: BaseState {
    var context: BehaviorRelay<RouteContext?> = BehaviorRelay(value: nil)

    var pageState: BehaviorRelay<PageState> = BehaviorRelay(value: .initial)
    var billInfo: BehaviorRelay<BillModel> = BehaviorRelay(value: BillModel())
    var orderInfo: PublishRelay<(BillModel?, Bool)> = PublishRelay()
    var orderId = ""
    var nums: Int = 0
}

// MARK: - Action
struct PayToActivateFetchedAction: Action {
    var data: JSON
}

struct OrderAction: Action {
    var order: Order
}

struct NumsAction: Action {
    var nums: Int
}

struct BillModel {
    var cpu = "0.0000 EOS"
    var net = "0.0000 EOS"
    var ram = "0.0000 EOS"
    var rmb = "0.00 RMB"
}

struct WXPayModel {
    var appid = ""
    var noncestr = ""
    var partnerid = ""
    var prepayid = ""
    var timestamp = ""
    var sign = ""
}

struct BillAction: Action {
    var data: Bill
}
