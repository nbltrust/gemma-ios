//
//  ResourceMortgageActions.swift
//  EOS
//
//  Created zhusongyu on 2018/7/24.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import ReSwift
import RxCocoa
import SwiftyJSON

//MARK: - State
struct ResourceMortgageState: StateType {
    var isLoading = false
    var page: Int = 1
    var errorMessage:String?
    var property: ResourceMortgagePropertyState
}

//struct MortgageViewModel {
//    var account:String = "-"
//    var portrait:String = ""
//    var allAssets:String = "- \(NetworkConfiguration.EOSIO_DEFAULT_SYMBOL)"// 1.0000 EOS
//    var balance:String = "- \(NetworkConfiguration.EOSIO_DEFAULT_SYMBOL)"
//    var CNY:String = "≈- CNY"
//    var recentRefundAsset:String = "- \(NetworkConfiguration.EOSIO_DEFAULT_SYMBOL)"
//    var refundTime:String = ""
//    var cpuValue:String = "- \(NetworkConfiguration.EOSIO_DEFAULT_SYMBOL)"
//    var netValue:String = "- \(NetworkConfiguration.EOSIO_DEFAULT_SYMBOL)"
//    var ramValue:String = "- \(NetworkConfiguration.EOSIO_DEFAULT_SYMBOL)"
//}

struct ResourceMortgagePropertyState {
    var info:BehaviorRelay<AccountViewModel> = BehaviorRelay(value: AccountViewModel())
    var CNY_price:String = ""
}
//
//struct MBalanceFetchedAction:Action {
//    var balance:JSON
//}
//
//struct MAccountFetchedAction:Action {
//    var info:Account
//}
//
//struct MRMBPriceFetchedAction:Action {
//    var price:JSON
//}

//MARK: - Action Creator
class ResourceMortgagePropertyActionCreate {
    public typealias ActionCreator = (_ state: ResourceMortgageState, _ store: Store<ResourceMortgageState>) -> Action?
    
    public typealias AsyncActionCreator = (
        _ state: ResourceMortgageState,
        _ store: Store <ResourceMortgageState>,
        _ actionCreatorCallback: @escaping ((ActionCreator) -> Void)
        ) -> Void
}
