//
//  NormalCurrencyListActions.swift
//  EOS
//
//  Created peng zhu on 2018/12/6.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation
import ReSwift
import RxCocoa
import SwiftyJSON
import HandyJSON

struct NormalCurrencyListContext: RouteContext, HandyJSON {
    init() {}
    
}

//MARK: - State
struct NormalCurrencyListState: BaseState {
    var context: BehaviorRelay<RouteContext?> = BehaviorRelay(value: nil)
    var pageState: BehaviorRelay<PageState> = BehaviorRelay(value: .initial)
}

//MARK: - Action
struct NormalCurrencyListFetchedAction: Action {
    var data:JSON
}
