//
//  BLTCardSetFingerPrinterActions.swift
//  EOS
//
//  Created peng zhu on 2018/9/25.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import Foundation
import ReSwift
import RxCocoa
import SwiftyJSON

// MARK: - State
struct BLTCardSetFingerPrinterState: BaseState {
    var context: BehaviorRelay<RouteContext?> = BehaviorRelay(value: nil)

    var pageState: BehaviorRelay<PageState> = BehaviorRelay(value: .initial)
}

// MARK: - Action
struct BLTCardSetFingerPrinterFetchedAction: Action {
    var data: JSON
}
