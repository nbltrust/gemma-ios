//
//  NewHomeActions.swift
//  EOS
//
//  Created zhusongyu on 2018/10/17.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation
import ReSwift
import RxCocoa
import SwiftyJSON
import HandyJSON

struct NewHomeContext: RouteContext, HandyJSON {
    init() {}

}

// MARK: - State
struct NewHomeState: BaseState {
    var context: BehaviorRelay<RouteContext?> = BehaviorRelay(value: nil)
    var pageState: BehaviorRelay<PageState> = BehaviorRelay(value: .initial)
    var info: BehaviorRelay<NewHomeViewModel> = BehaviorRelay(value: NewHomeViewModel())
    var cnyPrice: String = ""
    var otherPrice: String = ""
}

// MARK: - Action
struct NewHomeFetchedAction: Action {
    var data: JSON
}

struct NewHomeViewModel: HandyJSON {
    var currencyIcon: String = ""
    var currency: String = ""
    var account: String  = ""
    var currencyImg: UIImage = R.image.eosBg()!
    var balance: String  = ""
    var allAssets: String = "- \(NetworkConfiguration.EOSIODefaultSymbol)"// 1.0000 EOS
    var CNY: String  = ""
    var tokens: String  = ""
    var unit: String  = ""
    var tokenArray: [String] = []
    var cpuValue: String = "- \(NetworkConfiguration.EOSIODefaultSymbol)"
    var netValue: String = "- \(NetworkConfiguration.EOSIODefaultSymbol)"
    var ramValue: String = "- \(NetworkConfiguration.EOSIODefaultSymbol)"
    var id: Int64 = 0
}

struct BalanceFetchedAction: Action {
    var currencyID: Int64?
}

struct AccountFetchedAction: Action {
    var currencyID: Int64?
}

struct AccountFetchedFromLocalAction: Action {
    var model: AccountModel?
}

struct RMBPriceFetchedAction: Action {
    var currencyID: Int64?
}

struct NonActiveFetchedAction: Action {
    var currency: Currency?
}
