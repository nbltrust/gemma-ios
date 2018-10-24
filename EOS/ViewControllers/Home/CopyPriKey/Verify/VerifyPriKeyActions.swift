//
//  VerifyPriKeyActions.swift
//  EOS
//
//  Created zhusongyu on 2018/9/25.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation
import ReSwift
import RxCocoa
import SwiftyJSON

// MARK: - State
struct VerifyPriKeyState: BaseState {
    var context: BehaviorRelay<RouteContext?> = BehaviorRelay(value: nil)

    var pageState: BehaviorRelay<PageState> = BehaviorRelay(value: .initial)
}

// MARK: - Action
struct VerifyPriKeyFetchedAction: Action {
    var data: JSON
}
