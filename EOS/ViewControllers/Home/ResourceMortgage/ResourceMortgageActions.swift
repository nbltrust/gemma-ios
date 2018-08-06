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

struct GeneralViewModel {
    var name = ""
    var eos = "- EOS"
    var leftSub = ""
    var rightSub = ""
    var lineHidden = false
    var progress: Float = 0.5
}

struct ResourceViewModel {
    var general: [GeneralViewModel]
    var page: PageViewModel
}

struct PageViewModel {
    var balance = ""
    var leftText = ""
    var rightText = ""
    var operationLeft: [OperationViewModel]
    var operationRight: [OperationViewModel]
}

struct OperationViewModel {
    var title = ""
    var placeholder = ""
    var warning = ""
    var introduce = ""
    var isShowPromptWhenEditing = true
    var showLine = true
    var isSecureTextEntry = false
}

struct ResourceMortgagePropertyState {
    var info:BehaviorRelay<ResourceViewModel?> = BehaviorRelay(value: nil)
    var cpuMoneyValid: BehaviorRelay<(Bool,String,String)> = BehaviorRelay(value: (false,"",""))
    var netMoneyValid: BehaviorRelay<(Bool,String,String)> = BehaviorRelay(value: (false,"",""))
    var cpuReliveMoneyValid: BehaviorRelay<(Bool,String,String)> = BehaviorRelay(value: (false,"",""))
    var netReliveMoneyValid: BehaviorRelay<(Bool,String,String)> = BehaviorRelay(value: (false,"",""))
    var CNY_price:String = ""
}

struct cpuMoneyAction: Action {
    var cpuMoney = ""
    var netMoney = ""
    var balance = ""
}

struct netMoneyAction: Action {
    var cpuMoney = ""
    var netMoney = ""
    var balance = ""
}

struct cpuReliveMoneyAction: Action {
    var cpuMoney = ""
    var netMoney = ""
    var balance = ""
}

struct netReliveMoneyAction: Action {
    var cpuMoney = ""
    var netMoney = ""
    var balance = ""
}

struct MBalanceFetchedAction:Action {
    var balance:JSON
}

struct MAccountFetchedAction:Action {
    var info:Account
}

//MARK: - Action Creator
class ResourceMortgagePropertyActionCreate {
    public typealias ActionCreator = (_ state: ResourceMortgageState, _ store: Store<ResourceMortgageState>) -> Action?
    
    public typealias AsyncActionCreator = (
        _ state: ResourceMortgageState,
        _ store: Store <ResourceMortgageState>,
        _ actionCreatorCallback: @escaping ((ActionCreator) -> Void)
        ) -> Void
}
