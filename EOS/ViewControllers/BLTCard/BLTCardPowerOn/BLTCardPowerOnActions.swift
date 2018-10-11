//
//  BLTCardPowerOnActions.swift
//  EOS
//
//  Created peng zhu on 2018/9/30.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import Foundation
import ReSwift
import RxCocoa
import SwiftyJSON
import HandyJSON

struct BLTCardPowerOnContext: RouteContext, HandyJSON {
    init() {}
    
}

//MARK: - State
struct BLTCardPowerOnState: BaseState {
    var context: BehaviorRelay<RouteContext?> = BehaviorRelay(value: nil)
    var pageState: BehaviorRelay<PageState> = BehaviorRelay(value: .initial)
}

//MARK: - Action
struct BLTCardPowerOnFetchedAction: Action {
    var data:JSON
}
