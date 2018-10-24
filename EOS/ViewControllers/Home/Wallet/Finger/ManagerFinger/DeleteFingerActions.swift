//
//  DeleteFingerActions.swift
//  EOS
//
//  Created zhusongyu on 2018/10/12.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation
import ReSwift
import RxCocoa
import SwiftyJSON
import HandyJSON

struct DeleteFingerContext: RouteContext, HandyJSON {
    init() {}

}

// MARK: - State
struct DeleteFingerState: BaseState {
    var context: BehaviorRelay<RouteContext?> = BehaviorRelay(value: nil)
    var pageState: BehaviorRelay<PageState> = BehaviorRelay(value: .initial)
}

// MARK: - Action
struct DeleteFingerFetchedAction: Action {
    var data: JSON
}
