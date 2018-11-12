//
//  AssetDetailActions.swift
//  EOS
//
//  Created zhusongyu on 2018/10/30.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation
import ReSwift
import RxCocoa
import SwiftyJSON
import HandyJSON

struct AssetDetailContext: RouteContext, HandyJSON {
    init() {}
    var model = AssetViewModel()
}

//MARK: - State
struct AssetDetailState: BaseState {
    var context: BehaviorRelay<RouteContext?> = BehaviorRelay(value: nil)
    var pageState: BehaviorRelay<PageState> = BehaviorRelay(value: .initial)
    var data: [String: [PaymentsRecordsViewModel]] = [:]
    var lastPos: Int = -1
    var payments: [Payment] = []
}

//MARK: - Action
struct AssetDetailFetchedAction: Action {
    var data:JSON
}

struct RemoveAction: Action {
    
}
