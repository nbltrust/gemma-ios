//
//  TransferActions.swift
//  EOS
//
//  Created DKM on 2018/7/11.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import ReSwift
import RxSwift
import RxCocoa
import HandyJSON

struct TransferContext: RouteContext, HandyJSON {
    init() {

    }

}

// MARK: - State
struct TransferState: BaseState {
    var pageState: BehaviorRelay<PageState> = BehaviorRelay(value: .initial)

    var context: BehaviorRelay<RouteContext?> = BehaviorRelay(value: nil)

    var balance: BehaviorRelay<String?> = BehaviorRelay(value: "")
    var moneyValid: BehaviorRelay<(Bool, String)> = BehaviorRelay(value: (false, ""))
    var toNameValid: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var balanceLocal: BehaviorRelay<String?> = BehaviorRelay(value: "")
}

struct MoneyAction: Action {
    var money = ""
    var balance = ""
}

struct ToNameAction: Action {
    var isValid: Bool = false
}

struct TBalanceFetchedAction: Action {
    var account: String?
}
