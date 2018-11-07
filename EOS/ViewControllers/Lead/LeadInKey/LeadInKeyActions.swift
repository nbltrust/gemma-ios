//
//  LeadInKeyActions.swift
//  EOS
//
//  Created peng zhu on 2018/11/2.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation
import ReSwift
import RxCocoa
import SwiftyJSON
import HandyJSON

struct LeadInKeyContext: RouteContext, HandyJSON {
}

//MARK: - State
struct LeadInKeyState: BaseState {
    var context: BehaviorRelay<RouteContext?> = BehaviorRelay(value: nil)
    var pageState: BehaviorRelay<PageState> = BehaviorRelay(value: .initial)
    var currencyType: BehaviorRelay<CurrencyType?> = BehaviorRelay(value: CurrencyType.EOS)
    var toWallet: BehaviorRelay<Wallet?> = BehaviorRelay(value: nil)
}

//MARK: - Action
struct LeadInKeyFetchedAction: Action {
    var data:JSON
}
