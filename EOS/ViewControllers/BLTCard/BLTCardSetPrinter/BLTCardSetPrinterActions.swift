//
//  BLTCardSetPrinterActions.swift
//  EOS
//
//  Created peng zhu on 2018/9/20.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import Foundation
import ReSwift
import RxCocoa
import SwiftyJSON

// MARK: - State
struct BLTCardSetPrinterState: BaseState {
    var context: BehaviorRelay<RouteContext?> = BehaviorRelay(value: nil)

    var pageState: BehaviorRelay<PageState> = BehaviorRelay(value: .initial)
    var checkFingerData: BehaviorRelay<(isScueess: Bool, accessCount: Int)> = BehaviorRelay(value: (false, 0))
}

// MARK: - Action
struct BLTCardSetPrinterFetchedAction: Action {
    var data: JSON
}

struct BLTSetCheckFingerDataAction: Action {
    var data = (false, 0)
}
