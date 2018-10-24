//
//  ScanActions.swift
//  EOS
//
//  Created peng zhu on 2018/7/16.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import ReSwift
import RxCocoa
import HandyJSON

struct ScanContext: RouteContext, HandyJSON {
    var scanResult: BehaviorRelay<ScanResult?> = BehaviorRelay(value: nil)
}

typealias ScanResult = ((_ pickurler: String) -> Void)
// MARK: - State
struct ScanState: BaseState {
    var pageState: BehaviorRelay<PageState> = BehaviorRelay(value: .initial)

    var context: BehaviorRelay<RouteContext?> = BehaviorRelay(value: nil)
}
