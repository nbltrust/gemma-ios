//
//  LeadInMnemonicActions.swift
//  EOS
//
//  Created peng zhu on 2018/10/30.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation
import ReSwift
import RxCocoa
import SwiftyJSON
import HandyJSON

struct LeadInMnemonicContext: RouteContext, HandyJSON {
    init() {}
    
}

//MARK: - State
struct LeadInMnemonicState: BaseState {
    var context: BehaviorRelay<RouteContext?> = BehaviorRelay(value: nil)
    var pageState: BehaviorRelay<PageState> = BehaviorRelay(value: .initial)
}

//MARK: - Action
struct LeadInMnemonicFetchedAction: Action {
    var data:JSON
}
