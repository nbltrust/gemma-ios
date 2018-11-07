//
//  ResourceDetailActions.swift
//  EOS
//
//  Created zhusongyu on 2018/11/1.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation
import ReSwift
import RxCocoa
import SwiftyJSON
import HandyJSON

struct ResourceDetailContext: RouteContext, HandyJSON {
    init() {}
    
}

//MARK: - State
struct ResourceDetailState: BaseState {
    var context: BehaviorRelay<RouteContext?> = BehaviorRelay(value: nil)
    var pageState: BehaviorRelay<PageState> = BehaviorRelay(value: .initial)
    var info: BehaviorRelay<ResourceViewModel?> = BehaviorRelay(value: nil)
}

//MARK: - Action
struct ResourceDetailFetchedAction: Action {
    var data:JSON
}
