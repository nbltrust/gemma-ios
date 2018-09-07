//
//  PayToActivateActions.swift
//  EOS
//
//  Created zhusongyu on 2018/9/6.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import Foundation
import ReSwift
import RxCocoa
import SwiftyJSON

//MARK: - State
struct PayToActivateState: BaseState {
    var pageState: BehaviorRelay<PageState> = BehaviorRelay(value: .initial)
}

//MARK: - Action
struct PayToActivateFetchedAction: Action {
    var data:JSON
}

struct PayAdapterModel {
    var cpu = ""
    var net = ""
    var ram = ""
    var rmb = ""
}
