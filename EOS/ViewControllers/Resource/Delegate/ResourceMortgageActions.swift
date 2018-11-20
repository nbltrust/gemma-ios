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

// MARK: - State
struct ResourceMortgageState: StateType {
    var isLoading = false
    var page: Int = 1
    var errorMessage: String?
    var property: ResourceMortgagePropertyState
}

struct GeneralViewModel {
    var name = ""
    var eos = "0.0000 EOS"
    var leftSub = ""
    var rightSub = ""
    var lineHidden = false
    var progress: Float = 0.5
    var delegatedBandwidth = "0.0000 EOS"
}

struct ResourceViewModel {
    var general: [GeneralViewModel]
    var balance = ""
}

struct PageViewModel {
    var leftText = ""
    var rightText = ""
    var operationLeft: [OperationViewModel] = []
    var operationRight: [OperationViewModel] = []
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

struct InputMoney {
    var cpuMoney = ""
    var netMoney = ""
}

struct ValidInfo {
    var isValid = false
    var waningTip = ""
}

struct ResourceMortgagePropertyState {
    var info: BehaviorRelay<PageViewModel?> = BehaviorRelay(value: nil)
    var cpuMoneyValid: BehaviorRelay<(ValidInfo, InputMoney)> = BehaviorRelay(value: (ValidInfo(), InputMoney()))
    var netMoneyValid: BehaviorRelay<(ValidInfo, InputMoney)> = BehaviorRelay(value: (ValidInfo(), InputMoney()))
    var cpuReliveMoneyValid: BehaviorRelay<(ValidInfo, InputMoney)> = BehaviorRelay(value: (ValidInfo(), InputMoney()))
    var netReliveMoneyValid: BehaviorRelay<(ValidInfo, InputMoney)> = BehaviorRelay(value: (ValidInfo(), InputMoney()))
    var CNYPrice: String = ""
}

struct CpuMoneyAction: Action {
    var cpuMoney = ""
    var netMoney = ""
    var balance = ""
}

struct NetMoneyAction: Action {
    var cpuMoney = ""
    var netMoney = ""
    var balance = ""
}

struct CpuReliveMoneyAction: Action {
    var cpuMoney = ""
    var netMoney = ""
    var balance = ""
}

struct NetReliveMoneyAction: Action {
    var cpuMoney = ""
    var netMoney = ""
    var balance = ""
}

struct MBalanceFetchedAction: Action {
    var balance: JSON
}

struct MAccountFetchedAction: Action {
    var info: Account
}

struct FetchDataAction: Action {
    var balance = ""
    var cpuBalance = ""
    var netBalance = ""
}

// MARK: - Action Creator
class ResourceMortgagePropertyActionCreate {
    public typealias ActionCreator = (_ state: ResourceMortgageState, _ store: Store<ResourceMortgageState>) -> Action?

    public typealias AsyncActionCreator = (
        _ state: ResourceMortgageState,
        _ store: Store <ResourceMortgageState>,
        _ actionCreatorCallback: @escaping ((ActionCreator) -> Void)
        ) -> Void
}
