//
//  VerifyMnemonicWordActions.swift
//  EOS
//
//  Created zhusongyu on 2018/9/13.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import Foundation
import ReSwift
import RxCocoa
import SwiftyJSON

// MARK: - State
struct VerifyMnemonicWordState: BaseState {
    var context: BehaviorRelay<RouteContext?> = BehaviorRelay(value: nil)

    var pageState: BehaviorRelay<PageState> = BehaviorRelay(value: .initial)
}

// MARK: - Action
struct VerifyMnemonicWordFetchedAction: Action {
    var data: JSON
}
