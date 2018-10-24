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
}

// MARK: - Action
struct NewHomeFetchedAction: Action {
    var data: JSON
}

struct NewHomeViewModel {
    var currencyIcon = ""
    var currency = ""
    var account = ""
    var currencyImg: UIImage = R.image.eosBg()!
    var balance = ""
    var otherBalance = ""
    var tokens = ""
    var unit = ""
    var tokenArray: [String] = []
}
