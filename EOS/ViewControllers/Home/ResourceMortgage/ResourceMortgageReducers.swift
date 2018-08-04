//
//  ResourceMortgageReducers.swift
//  EOS
//
//  Created zhusongyu on 2018/7/24.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

func ResourceMortgageReducer(action:Action, state:ResourceMortgageState?) -> ResourceMortgageState {
    return ResourceMortgageState(isLoading: loadingReducer(state?.isLoading, action: action), page: pageReducer(state?.page, action: action), errorMessage: errorMessageReducer(state?.errorMessage, action: action), property: ResourceMortgagePropertyReducer(state?.property, action: action))
}

func ResourceMortgagePropertyReducer(_ state: ResourceMortgagePropertyState?, action: Action) -> ResourceMortgagePropertyState {
    var state = state ?? ResourceMortgagePropertyState()
    
    switch action {
    case let action as cpuMoneyAction:
        if let balanceDouble = action.balance.components(separatedBy: " ")[0].toDouble(), let cpuMoneyDouble = action.cpuMoney.toDouble(), let netMoneyDouble = action.netMoney.toDouble() {
            var valid = false
            var tips = R.string.localizable.big_money()
            if balanceDouble >= cpuMoneyDouble + netMoneyDouble {
                valid = true
                tips = ""
            }
            
            if cpuMoneyDouble < (1 / pow(10, AppConfiguration.EOS_PRECISION)).doubleValue,action.cpuMoney != "" {
                valid = false
                tips = R.string.localizable.small_money()
            }
            
            state.cpuMoneyValid.accept((valid,tips,action.cpuMoney))
        }
    case let action as netMoneyAction:
        if let balanceDouble = action.balance.components(separatedBy: " ")[0].toDouble(), let cpuMoneyDouble = action.cpuMoney.toDouble(), let netMoneyDouble = action.netMoney.toDouble() {
            var valid = false
            var tips = R.string.localizable.big_money()
            if balanceDouble >= cpuMoneyDouble + netMoneyDouble {
                valid = true
                tips = ""
            }
            
            if netMoneyDouble < (1 / pow(10, AppConfiguration.EOS_PRECISION)).doubleValue,action.netMoney != "" {
                valid = false
                tips = R.string.localizable.small_money()
            }
            
            state.netMoneyValid.accept((valid,tips,action.netMoney))
        }
    case let action as cpuReliveMoneyAction:
        if let balanceDouble = action.balance.components(separatedBy: " ")[0].toDouble(), let cpuMoneyDouble = action.cpuMoney.toDouble(), let netMoneyDouble = action.netMoney.toDouble() {
            var valid = false
            var tips = R.string.localizable.big_money()
            if balanceDouble >= cpuMoneyDouble + netMoneyDouble {
                valid = true
                tips = ""
            }
            
            if cpuMoneyDouble < (1 / pow(10, AppConfiguration.EOS_PRECISION)).doubleValue,action.cpuMoney != "" {
                valid = false
                tips = R.string.localizable.small_money()
            }
            
            state.cpuReliveMoneyValid.accept((valid,tips,action.cpuMoney))
        }
    case let action as netReliveMoneyAction:
        if let balanceDouble = action.balance.components(separatedBy: " ")[0].toDouble(), let cpuMoneyDouble = action.cpuMoney.toDouble(), let netMoneyDouble = action.netMoney.toDouble() {
            var valid = false
            var tips = R.string.localizable.big_money()
            if balanceDouble >= cpuMoneyDouble + netMoneyDouble {
                valid = true
                tips = ""
            }
            
            if netMoneyDouble < (1 / pow(10, AppConfiguration.EOS_PRECISION)).doubleValue,action.netMoney != "" {
                valid = false
                tips = R.string.localizable.small_money()
            }
            
            state.netReliveMoneyValid.accept((valid,tips,action.netMoney))
        }
    case let action as MBalanceFetchedAction:
        if var viewmodel = state.info.value {
            if let balance = action.balance.arrayValue.first?.string {
                viewmodel.page.balance = balance
            }
            else {
                viewmodel.page.balance = "- \(NetworkConfiguration.EOSIO_DEFAULT_SYMBOL)"
            }
            state.info.accept(viewmodel)
        } else {
            var viewmodel = initViewModel()
            if let balance = action.balance.arrayValue.first?.string {
                viewmodel.page.balance = balance
            }
            else {
                viewmodel.page.balance = "- \(NetworkConfiguration.EOSIO_DEFAULT_SYMBOL)"
            }
            state.info.accept(viewmodel)
        }
        
        
    case let action as MAccountFetchedAction:
        var viewmodel = state.info.value
        viewmodel = convertResourceViewModelWithAccount(action.info, viewmodel:viewmodel)
            state.info.accept(viewmodel)
    default:
        break
    }
    
    return state
}

func initViewModel() -> ResourceViewModel {
    let newViewModel = ResourceViewModel(general: [GeneralViewModel(name: R.string.localizable.cpu(), eos: "- EOS", leftSub: R.string.localizable.use() + " - " + R.string.localizable.ms(), rightSub: R.string.localizable.total() + " - " + R.string.localizable.ms(), lineHidden: false, progress: 0.5),GeneralViewModel(name: R.string.localizable.net(), eos: "- EOS", leftSub: R.string.localizable.use() + " - " + R.string.localizable.kb(), rightSub: R.string.localizable.total() + " - " + R.string.localizable.kb(), lineHidden: true, progress: 0.5)], page: PageViewModel(balance: "- EOS", leftText: R.string.localizable.mortgage_resource(), rightText: R.string.localizable.cancel_mortgage(), operationLeft: [OperationViewModel(title: R.string.localizable.mortgage_cpu(), placeholder: R.string.localizable.mortgage_placeholder(), warning: "", introduce: "", isShowPromptWhenEditing: true, showLine: true, isSecureTextEntry: false),OperationViewModel(title: R.string.localizable.mortgage_net(), placeholder: R.string.localizable.mortgage_placeholder(), warning: "", introduce: "", isShowPromptWhenEditing: true, showLine: false, isSecureTextEntry: false)], operationRight: [OperationViewModel(title: R.string.localizable.cpu(), placeholder: R.string.localizable.mortgage_cancel_placeholder(), warning: "", introduce: "", isShowPromptWhenEditing: true, showLine: true, isSecureTextEntry: false),OperationViewModel(title: R.string.localizable.net(), placeholder: R.string.localizable.mortgage_cancel_placeholder(), warning: "", introduce: "", isShowPromptWhenEditing: true, showLine: false, isSecureTextEntry: false)]))
    return newViewModel
}

func convertResourceViewModelWithAccount(_ account:Account, viewmodel:ResourceViewModel?) -> ResourceViewModel {
    if var newViewModel = viewmodel {
        newViewModel.general[0].eos = account.total_resources?.cpu_weight ?? "- \(NetworkConfiguration.EOSIO_DEFAULT_SYMBOL)"
        newViewModel.general[1].eos = account.total_resources?.net_weight ?? "- \(NetworkConfiguration.EOSIO_DEFAULT_SYMBOL)"
        if let used = account.cpu_limit?.used.string,let max = account.cpu_limit?.max.string {
            newViewModel.general[0].leftSub = R.string.localizable.use() + " \(used) " + R.string.localizable.ms()
            newViewModel.general[0].rightSub = R.string.localizable.total() + " \(max) " + R.string.localizable.ms()
            newViewModel.general[0].progress = used.float()! / max.float()!
        }
        if let used = account.net_limit?.used.string,let max = account.cpu_limit?.max.string  {
            newViewModel.general[1].leftSub = R.string.localizable.use() + " \(used) " + R.string.localizable.kb()
            newViewModel.general[1].rightSub = R.string.localizable.total() + " \(max) " + R.string.localizable.kb()
            newViewModel.general[1].progress = used.float()! / max.float()!
        }
        return newViewModel
    } else {
        var newViewModel = initViewModel()
        newViewModel = convertResourceViewModelWithAccount(account, viewmodel: newViewModel)
        return newViewModel
    }
}

//func calculateTotalAsset(_ viewmodel:MortgageViewModel) -> String {
//    if let balance = viewmodel.balance.eosAmount.toDouble(), let cpu = viewmodel.cpuValue.eosAmount.toDouble(),
//        let net = viewmodel.netValue.eosAmount.toDouble() {
//        let total = balance + cpu + net
//        
//        return total.string(digits: AppConfiguration.EOS_PRECISION) + " \(NetworkConfiguration.EOSIO_DEFAULT_SYMBOL)"
//    }
//    else {
//        return "- \(NetworkConfiguration.EOSIO_DEFAULT_SYMBOL)"
//    }
//}
//
//func calculateRMBPrice(_ viewmodel:MortgageViewModel, price:String) -> String {
//    if let unit = price.toDouble(), unit != 0, let all = viewmodel.allAssets.eosAmount.toDouble(), all != 0 {
//        let cny = unit * all
//        return "≈" + cny.string(digits: 2) + " CNY"
//    }
//    else {
//        return "≈- CNY"
//    }
//}


