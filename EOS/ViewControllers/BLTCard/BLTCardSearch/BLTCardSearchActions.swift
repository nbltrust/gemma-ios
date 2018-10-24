//
//  BLTCardSearchActions.swift
//  EOS
//
//  Created peng zhu on 2018/9/13.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import Foundation
import ReSwift
import RxCocoa
import SwiftyJSON

// MARK: - State
struct BLTCardSearchState: BaseState {
    var context: BehaviorRelay<RouteContext?> = BehaviorRelay(value: nil)

    var pageState: BehaviorRelay<PageState> = BehaviorRelay(value: .initial)

    var devices: [BLTDevice] = []
}

// MARK: - Action
struct BLTCardSearchFetchedAction: Action {
    var data: JSON
}

struct SetDevicesAction: Action {
    var datas: [BLTDevice]
}
