//
//  OverviewActions.swift
//  EOS
//
//  Created zhusongyu on 2018/10/30.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation
import ReSwift
import RxCocoa
import SwiftyJSON
import HandyJSON

struct OverviewContext: RouteContext, HandyJSON {
    init() {}
    
}

//MARK: - State
struct OverviewState: BaseState {
    var context: BehaviorRelay<RouteContext?> = BehaviorRelay(value: nil)
    var pageState: BehaviorRelay<PageState> = BehaviorRelay(value: .initial)
    var info: BehaviorRelay<NewHomeViewModel?> = BehaviorRelay(value: nil)
    var tokens: BehaviorRelay<[AssetViewModel]?> = BehaviorRelay(value: nil)
    var cnyPrice: String = ""
    var otherPrice: String = ""
}

//MARK: - Action
struct OverviewFetchedAction: Action {
    var data:JSON
}

struct TokensFetchedAction: Action {
    var data:[Tokens]
}

struct AssetViewModel {
    var iconUrl: String = ""
    var name: String = ""
    var total: String = ""
    var CNY: String = ""
    var contract: String = ""
    var balance: String = ""
}
