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
            
            if cpuMoneyDouble < (1 / pow(10, AppConfiguration.EOS_PRECISION)).doubleValue {
                valid = false
                tips = R.string.localizable.small_money()
            }
            
            state.cpuMoneyValid.accept((valid,tips))
        }
    case let action as netMoneyAction:
        if let balanceDouble = action.balance.components(separatedBy: " ")[0].toDouble(), let cpuMoneyDouble = action.cpuMoney.toDouble(), let netMoneyDouble = action.netMoney.toDouble() {
            var valid = false
            var tips = R.string.localizable.big_money()
            if balanceDouble >= cpuMoneyDouble + netMoneyDouble {
                valid = true
                tips = ""
            }
            
            if netMoneyDouble < (1 / pow(10, AppConfiguration.EOS_PRECISION)).doubleValue {
                valid = false
                tips = R.string.localizable.small_money()
            }
            
            state.netMoneyValid.accept((valid,tips))
        }
    case let action as MBalanceFetchedAction:
        var viewmodel = state.info.value

//        viewmodel = convertResourceViewModel()

        if let balance = action.balance.arrayValue.first?.string {
            viewmodel?.page.balance = balance

        }
        else {
            viewmodel?.page.balance = "- \(NetworkConfiguration.EOSIO_DEFAULT_SYMBOL)"
        }
//
//        viewmodel.allAssets = calculateTotalAsset(viewmodel)
//        viewmodel.CNY = calculateRMBPrice(viewmodel, price:state.CNY_price)
        state.info.accept(viewmodel)

    case let action as MAccountFetchedAction:
//        let viewmodel = convertResourceViewModel()
        
        var viewmodel = convertResourceViewModelWithAccount(action.info, viewmodel:state.info.value!)
//        viewmodel.CNY = calculateRMBPrice(viewmodel, price:state.CNY_price)
//
        state.info.accept(viewmodel)
    case let action as MRMBPriceFetchedAction:
//        let viewmodel = convertResourceViewModel()
        var viewmodel = state.info.value
        state.info.accept(viewmodel)
//        var viewmodel = state.info.value
//        state.CNY_price = action.price["value"].stringValue
//        
//        viewmodel.CNY = calculateRMBPrice(viewmodel, price:state.CNY_price)
//        state.info.accept(viewmodel)
    default:
        break
    }
    
    return state
}

func convertResourceViewModelWithAccount(_ account:Account, viewmodel:ResourceViewModel) -> ResourceViewModel {
    var newViewModel = viewmodel

//    let general = [GeneralViewModel(name: R.string.localizable.cpu(), eos: "0.100 EOS", leftSub: "已用0.100ms", rightSub: "总量10.29ms", lineHidden: false, progress: 0.5),GeneralViewModel(name: R.string.localizable.cpu(), eos: "0.100 EOS", leftSub: "已用0.100ms", rightSub: "总量10.29ms", lineHidden: false, progress: 0.8)]

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
}

//func initResourceViewModel() -> ResourceViewModel {
//    let leftOperation = [OperationViewModel(title: R.string.localizable.mortgage_cpu(), placeholder: R.string.localizable.mortgage_placeholder(), warning: "", introduce: "", isShowPromptWhenEditing: true, showLine: true, isSecureTextEntry: false),OperationViewModel(title: R.string.localizable.mortgage_net(), placeholder: R.string.localizable.mortgage_placeholder(), warning: "", introduce: "", isShowPromptWhenEditing: true, showLine: true, isSecureTextEntry: false)]
//
//    let rightOperation = [OperationViewModel(title: R.string.localizable.cpu(), placeholder: R.string.localizable.mortgage_cancel_placeholder(), warning: "", introduce: "", isShowPromptWhenEditing: true, showLine: true, isSecureTextEntry: false),OperationViewModel(title: R.string.localizable.net(), placeholder: R.string.localizable.mortgage_cancel_placeholder(), warning: "", introduce: "", isShowPromptWhenEditing: true, showLine: true, isSecureTextEntry: false)]
//
//    let general = [GeneralViewModel(name: R.string.localizable.cpu(), eos: "0.100 EOS", leftSub: "已用0.100ms", rightSub: "总量10.29ms", lineHidden: false, progress: 0.5),GeneralViewModel(name: R.string.localizable.cpu(), eos: "0.100 EOS", leftSub: "已用0.100ms", rightSub: "总量10.29ms", lineHidden: false, progress: 0.8)]
//
//    let page = PageViewModel(balance: "0.01 EOS", leftText: R.string.localizable.mortgage_resource(), rightText: R.string.localizable.cancel_mortgage(), operationLeft: leftOperation, operationRight: rightOperation)
//
//    let viewmodel:ResourceViewModel = ResourceViewModel(general: general, page: page)
//
//    return viewmodel
//}

func calculateTotalAsset(_ viewmodel:MortgageViewModel) -> String {
    if let balance = viewmodel.balance.eosAmount.toDouble(), let cpu = viewmodel.cpuValue.eosAmount.toDouble(),
        let net = viewmodel.netValue.eosAmount.toDouble() {
        let total = balance + cpu + net
        
        return total.string(digits: AppConfiguration.EOS_PRECISION) + " \(NetworkConfiguration.EOSIO_DEFAULT_SYMBOL)"
    }
    else {
        return "- \(NetworkConfiguration.EOSIO_DEFAULT_SYMBOL)"
    }
}

func calculateRMBPrice(_ viewmodel:MortgageViewModel, price:String) -> String {
    if let unit = price.toDouble(), unit != 0, let all = viewmodel.allAssets.eosAmount.toDouble(), all != 0 {
        let cny = unit * all
        return "≈" + cny.string(digits: 2) + " CNY"
    }
    else {
        return "≈- CNY"
    }
}


