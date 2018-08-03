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

struct MortgageViewModel {
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
    var info:BehaviorRelay<ResourceViewModel?> = BehaviorRelay(value: ResourceViewModel(general: [GeneralViewModel(name: R.string.localizable.cpu(), eos: "0.100 EOS", leftSub: R.string.localizable.use() + " - " + R.string.localizable.ms(), rightSub: R.string.localizable.total() + " - " + R.string.localizable.ms(), lineHidden: false, progress: 0.0),GeneralViewModel(name: R.string.localizable.net(), eos: "0.100 EOS", leftSub: R.string.localizable.use() + " - " + R.string.localizable.kb(), rightSub: R.string.localizable.total() + " - " + R.string.localizable.kb(), lineHidden: false, progress: 0.0)], page: PageViewModel(balance: "0.01 EOS", leftText: R.string.localizable.mortgage_resource(), rightText: R.string.localizable.cancel_mortgage(), operationLeft: [OperationViewModel(title: R.string.localizable.mortgage_cpu(), placeholder: R.string.localizable.mortgage_placeholder(), warning: "", introduce: "", isShowPromptWhenEditing: true, showLine: true, isSecureTextEntry: false),OperationViewModel(title: R.string.localizable.mortgage_net(), placeholder: R.string.localizable.mortgage_placeholder(), warning: "", introduce: "", isShowPromptWhenEditing: true, showLine: false, isSecureTextEntry: false)], operationRight: [OperationViewModel(title: R.string.localizable.cpu(), placeholder: R.string.localizable.mortgage_cancel_placeholder(), warning: "", introduce: "", isShowPromptWhenEditing: true, showLine: true, isSecureTextEntry: false),OperationViewModel(title: R.string.localizable.net(), placeholder: R.string.localizable.mortgage_cancel_placeholder(), warning: "", introduce: "", isShowPromptWhenEditing: true, showLine: false, isSecureTextEntry: false)])))
    var cpuMoneyValid: BehaviorRelay<(Bool,String)> = BehaviorRelay(value: (false,""))
    var netMoneyValid: BehaviorRelay<(Bool,String)> = BehaviorRelay(value: (false,""))
    var cpuReliveMoneyValid: BehaviorRelay<(Bool,String)> = BehaviorRelay(value: (false,""))
    var netReliveMoneyValid: BehaviorRelay<(Bool,String)> = BehaviorRelay(value: (false,""))
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
