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

//MARK: - State
struct PayToActivateState: BaseState {
    var pageState: BehaviorRelay<PageState> = BehaviorRelay(value: .initial)
    var billInfo: BehaviorRelay<BillModel> = BehaviorRelay(value: BillModel())
    var orderId = ""
}

//MARK: - Action
struct PayToActivateFetchedAction: Action {
    var data:JSON
}

struct OrderIdAction: Action {
    var orderId:String
}

struct BillModel {
    var cpu = ""
    var net = ""
    var ram = ""
    var rmb = ""
}

struct WXPayModel {
    var appid = ""
    var noncestr = ""
    var partnerid = ""
    var prepayid = ""
    var timestamp = ""
    var sign = ""
}

struct BillAction : Action {
    var data : Bill
}
