//
//  BLTCardConnectActions.swift
//  EOS
//
//  Created peng zhu on 2018/10/4.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import Foundation
import ReSwift
import RxCocoa
import SwiftyJSON
import HandyJSON

struct BLTCardConnectContext: RouteContext, HandyJSON {
    var connectSuccessed: CompletionCallback?
}

//MARK: - State
struct BLTCardConnectState: BaseState {
    var context: BehaviorRelay<RouteContext?> = BehaviorRelay(value: nil)
    var pageState: BehaviorRelay<PageState> = BehaviorRelay(value: .initial)
}

//MARK: - Action
struct BLTCardConnectFetchedAction: Action {
    var data:JSON
}
