//
//  MnemonicContentActions.swift
//  EOS
//
//  Created zhusongyu on 2018/9/14.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import Foundation
import ReSwift
import RxCocoa
import SwiftyJSON

// MARK: - State
struct MnemonicContentState: BaseState {
    var context: BehaviorRelay<RouteContext?> = BehaviorRelay(value: nil)

    var pageState: BehaviorRelay<PageState> = BehaviorRelay(value: .initial)

    var seedData: BehaviorRelay<([String], String)> = BehaviorRelay(value: ([], ""))
}

// MARK: - Action
struct MnemonicContentFetchedAction: Action {
    var data: JSON
}

struct SetSeedsAction: Action {
    var datas: ([String], String)
}
