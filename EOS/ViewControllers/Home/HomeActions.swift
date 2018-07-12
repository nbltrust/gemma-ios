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

//MARK: - State
struct HomeState: StateType {
    var isLoading = false
    var page: Int = 1
    var errorMessage:String?
    var property: HomePropertyState
}

struct AccountViewModel {
    var account:String = "-"
    var portrait:String = ""
    var allAssets:String = "- \(NetworkConfiguration.EOSIO_DEFAULT_SYMBOL)"// 1.0000 EOS
    var balance:String = "- \(NetworkConfiguration.EOSIO_DEFAULT_SYMBOL)"
    var CNY:String = "≈- CNY"
    var recentRefundAsset:String = "- \(NetworkConfiguration.EOSIO_DEFAULT_SYMBOL)"
    var refundTime:String = ""
    var cpuValue:String = "- \(NetworkConfiguration.EOSIO_DEFAULT_SYMBOL)"
    var netValue:String = "- \(NetworkConfiguration.EOSIO_DEFAULT_SYMBOL)"
    var ramValue:String = "- \(NetworkConfiguration.EOSIO_DEFAULT_SYMBOL)"
}

struct HomePropertyState {
    var info:BehaviorRelay<AccountViewModel> = BehaviorRelay(value: AccountViewModel())
    var CNY_price:String = ""
}

struct BalanceFetchedAction:Action {
    var balance:JSON
}

struct AccountFetchedAction:Action {
    var info:Account
}

struct RMBPriceFetchedAction:Action {
    var price:JSON
}

//MARK: - Action Creator
class HomePropertyActionCreate {
    public typealias ActionCreator = (_ state: HomeState, _ store: Store<HomeState>) -> Action?
    
    public typealias AsyncActionCreator = (
        _ state: HomeState,
        _ store: Store <HomeState>,
        _ actionCreatorCallback: @escaping ((ActionCreator) -> Void)
        ) -> Void
}
