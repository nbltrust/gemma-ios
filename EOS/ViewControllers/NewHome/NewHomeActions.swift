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
    var currencyIcon: UIImage = R.image.eos()!
    var currency: String = ""
    var account: String  = ""
    var currencyImg: UIImage = R.image.eosBg()!
    var balance: String  = "0.0000 \(NetworkConfiguration.EOSIODefaultSymbol)"
    var recentRefundAsset: String = "0.0000 \(NetworkConfiguration.EOSIODefaultSymbol)"
    var allAssets: String = "0.0000 \(NetworkConfiguration.EOSIODefaultSymbol)"// 1.0000 EOS
    var CNY: String  = "0.00"
    var tokens: String  = ""
    var unit: String  = ""
    var tokenArray: [String] = []
    var cpuValue: String = "- \(NetworkConfiguration.EOSIODefaultSymbol)"
    var netValue: String = "- \(NetworkConfiguration.EOSIODefaultSymbol)"
    var ramValue: String = "- \(NetworkConfiguration.EOSIODefaultSymbol)"
    var cpuProgress: Float = 0.0
    var netProgress: Float = 0.0
    var ramProgress: Float = 0.0
    var id: Int64 = 0
    var bottomIsHidden = true
}

struct BalanceFetchedAction: Action {
    var currency: Currency?
    var balance: JSON?
}

struct AccountFetchedAction: Action {
    var currency: Currency?
    var info: Account?
}

struct RMBPriceFetchedAction: Action {
    var currency: Currency?
}

struct NonActiveFetchedAction: Action {
    var currency: Currency?
}
