//
//  WalletCurrencyListActions.swift
//  EOS
//
//  Created peng zhu on 2018/11/15.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation
import ReSwift
import RxCocoa
import SwiftyJSON
import HandyJSON

struct WalletCurrencyListContext: RouteContext, HandyJSON {
    var wallet: Wallet?
}

//MARK: - State
struct WalletCurrencyListState: BaseState {
    var context: BehaviorRelay<RouteContext?> = BehaviorRelay(value: nil)
    var pageState: BehaviorRelay<PageState> = BehaviorRelay(value: .initial)
}

//MARK: - Action
struct WalletCurrencyListFetchedAction: Action {
    var data: JSON
}
