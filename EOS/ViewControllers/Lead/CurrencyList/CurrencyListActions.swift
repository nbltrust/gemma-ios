//
//  CurrencyListActions.swift
//  EOS
//
//  Created peng zhu on 2018/10/30.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation
import ReSwift
import RxCocoa
import SwiftyJSON
import HandyJSON

struct CurrencyListContext: RouteContext, HandyJSON {
    var selectedCurrency: CurrencyType = .EOS
    var currencySelectResult: BehaviorRelay<CurrencySelectResult?> = BehaviorRelay(value: nil)
}

typealias CurrencySelectResult = ((_ currencyType: CurrencyType) -> Void)
//MARK: - State
struct CurrencyListState: BaseState {
    var context: BehaviorRelay<RouteContext?> = BehaviorRelay(value: nil)
    var pageState: BehaviorRelay<PageState> = BehaviorRelay(value: .initial)
}

//MARK: - Action
struct CurrencyListFetchedAction: Action {
    var data:JSON
}
