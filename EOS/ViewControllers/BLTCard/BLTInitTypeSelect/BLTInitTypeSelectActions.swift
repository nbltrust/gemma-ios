//
//  BLTInitTypeSelectActions.swift
//  EOS
//
//  Created peng zhu on 2018/11/27.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation
import ReSwift
import RxCocoa
import SwiftyJSON
import HandyJSON

struct BLTInitTypeSelectContext: RouteContext, HandyJSON {
    var isCreateCallback: ResultCallback?
}

struct BLTInitTypeSelectState: BaseState {
    var context: BehaviorRelay<RouteContext?> = BehaviorRelay(value: nil)
    var pageState: BehaviorRelay<PageState> = BehaviorRelay(value: .initial)
}

struct BLTInitTypeSelectFetchedAction: Action {
    var data: JSON
}
