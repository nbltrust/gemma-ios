//
//  WalletListActions.swift
//  EOS
//
//  Created peng zhu on 2018/11/14.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation
import ReSwift
import RxCocoa
import SwiftyJSON
import HandyJSON

struct WalletListContext: RouteContext, HandyJSON {
    var walletList: [Wallet] = []
}

//MARK:State
struct WalletListState: BaseState {
    var context: BehaviorRelay<RouteContext?> = BehaviorRelay(value: nil)
    var pageState: BehaviorRelay<PageState> = BehaviorRelay(value: .initial)
}

//MARK:Action
struct WalletListFetchedAction: Action {
    var data: JSON
}
