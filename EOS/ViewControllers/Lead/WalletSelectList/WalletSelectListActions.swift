//
//  WalletSelectListActions.swift
//  EOS
//
//  Created peng zhu on 2018/11/1.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation
import ReSwift
import RxCocoa
import SwiftyJSON
import HandyJSON

typealias WalletSelectResult = ((_ wallet: Wallet) -> Void)
typealias ChooseNewWalletResult = (() -> Void)

struct WalletSelectListContext: RouteContext, HandyJSON {
    var selectedWallet: Wallet?
    var chooseNewWalletResult: BehaviorRelay<ChooseNewWalletResult?> = BehaviorRelay(value: nil)
    var walletSelectResult: BehaviorRelay<WalletSelectResult?> = BehaviorRelay(value: nil)
}

struct WalletSelectListState: BaseState {
    var context: BehaviorRelay<RouteContext?> = BehaviorRelay(value: nil)
    var pageState: BehaviorRelay<PageState> = BehaviorRelay(value: .initial)
}

struct WalletSelectListFetchedAction: Action {
    var data:JSON
}
