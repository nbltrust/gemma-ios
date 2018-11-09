//
//  ReceiptActions.swift
//  EOS
//
//  Created zhusongyu on 2018/11/7.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation
import ReSwift
import RxCocoa
import SwiftyJSON
import HandyJSON

struct ReceiptContext: RouteContext, HandyJSON {
    init() {}
    var model = AssetViewModel()
}

//MARK: - State
struct ReceiptState: BaseState {
    var context: BehaviorRelay<RouteContext?> = BehaviorRelay(value: nil)
    var pageState: BehaviorRelay<PageState> = BehaviorRelay(value: .initial)
}

//MARK: - Action
struct ReceiptFetchedAction: Action {
    var data:JSON
}
