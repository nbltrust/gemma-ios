//
//  BuyRamActions.swift
//  EOS
//
//  Created zhusongyu on 2018/8/9.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import Foundation
import ReSwift
import RxCocoa
import SwiftyJSON

// MARK: - State
struct BuyRamState: StateType {
    var isLoading = false
    var page: Int = 1
    var errorMessage: String?
    var property: BuyRamPropertyState
    var callback: BuyRamCallbackState
}

struct BuyRamPropertyState {
    var info: BehaviorRelay<BuyRamViewModel?> = BehaviorRelay(value: nil)
    var buyRamValid: BehaviorRelay<(Bool, String, String)> = BehaviorRelay(value: (false, "", ""))
    var sellRamValid: BehaviorRelay<(Bool, String, String)> = BehaviorRelay(value: (false, "", ""))
}

struct BuyRamViewModel {
    var leftSub = ""
    var rightSub = ""
    var progress: Float = 0.0
    var price: Decimal = 0
    var priceLabel = ""
    var exchange = ""
    var leftTrade = ""
    var rightTrade = ""
    var cpuMax: Int64 = 0
    var netMax: Int64 = 0
}

struct BuyRamAction: Action {
    var ram = ""
    var balance = ""
}

struct SellRamAction: Action {
    var ram = ""
    var balance = ""
}

struct RamPriceAction: Action {
    var price: Decimal
}

struct ExchangeAction: Action {
    var amount = ""
    var type: ExchangeType
}

enum ExchangeType {
    case left
    case right
}

struct BuyRamCallbackState {
}

// MARK: - Action Creator
class BuyRamPropertyActionCreate {
    public typealias ActionCreator = (_ state: BuyRamState, _ store: Store<BuyRamState>) -> Action?

    public typealias AsyncActionCreator = (
        _ state: BuyRamState,
        _ store: Store <BuyRamState>,
        _ actionCreatorCallback: @escaping ((ActionCreator) -> Void)
        ) -> Void
}
