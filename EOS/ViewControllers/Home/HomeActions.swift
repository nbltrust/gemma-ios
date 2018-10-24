//
//  HomeActions.swift
//  EOS
//
//  Created koofrank on 2018/7/4.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import ReSwift
import RxCocoa
import SwiftyJSON

// MARK: - State
struct HomeState: StateType {
    var isLoading = false
    var page: Int = 1
    var errorMessage: String?
    var property: HomePropertyState
}

struct AccountViewModel {
    var account: String = "-"
    var portrait: String = ""
    var allAssets: String = "- \(NetworkConfiguration.EOSIODefaultSymbol)"// 1.0000 EOS
    var balance: String = "- \(NetworkConfiguration.EOSIODefaultSymbol)"
    var CNY: String = "≈- CNY"
    var recentRefundAsset: String = "- \(NetworkConfiguration.EOSIODefaultSymbol)"
    var refundTime: String = ""
    var cpuValue: String = "- \(NetworkConfiguration.EOSIODefaultSymbol)"
    var netValue: String = "- \(NetworkConfiguration.EOSIODefaultSymbol)"
    var ramValue: String = "- \(NetworkConfiguration.EOSIODefaultSymbol)"
    var cpuProgress: Float = 0.0
    var netProgress: Float = 0.0
    var ramProgress: Float = 0.0
}

struct AccountListViewModel {
    var account: String = "-"
}

struct HomePropertyState {
    var info: BehaviorRelay<AccountViewModel> = BehaviorRelay(value: AccountViewModel())
    var model: BehaviorRelay<AccountViewModel> = BehaviorRelay(value: AccountViewModel())
    var cnyPrice: String = ""
    var otherPrice: String = ""
}

struct BalanceFetchedAction: Action {
    var balance: JSON?
}

struct AccountFetchedAction: Action {
    var info: Account?
}

struct AccountFetchedFromLocalAction: Action {
    var model: AccountModel?
}

struct RMBPriceFetchedAction: Action {
    var price: JSON?
    var otherPrice: JSON?
}

// MARK: - Action Creator
class HomePropertyActionCreate {
    public typealias ActionCreator = (_ state: HomeState, _ store: Store<HomeState>) -> Action?

    public typealias AsyncActionCreator = (
        _ state: HomeState,
        _ store: Store <HomeState>,
        _ actionCreatorCallback: @escaping ((ActionCreator) -> Void)
        ) -> Void
}
