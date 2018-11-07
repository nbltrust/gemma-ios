//
//  AccountListActions.swift
//  EOS
//
//  Created peng zhu on 2018/11/7.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation
import ReSwift
import RxCocoa
import SwiftyJSON
import HandyJSON

struct AccountListContext: RouteContext, HandyJSON {
    var didSelect: CompletionCallback?
}

//MARK: - State
struct AccountListState: BaseState {
    var context: BehaviorRelay<RouteContext?> = BehaviorRelay(value: nil)
    var pageState: BehaviorRelay<PageState> = BehaviorRelay(value: .initial)
}

//MARK: - Action
struct AccountListFetchedAction: Action {
    var data:JSON
}
