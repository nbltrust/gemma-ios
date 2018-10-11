//
//  ResourceMortgageReducers.swift
//  EOS
//
//  Created zhusongyu on 2018/7/24.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift
import SwiftyUserDefaults

func ResourceMortgageReducer(action:Action, state:ResourceMortgageState?) -> ResourceMortgageState {
    return ResourceMortgageState(isLoading: loadingReducer(state?.isLoading, action: action), page: pageReducer(state?.page, action: action), errorMessage: errorMessageReducer(state?.errorMessage, action: action), property: ResourceMortgagePropertyReducer(state?.property, action: action))
}

func ResourceMortgagePropertyReducer(_ state: ResourceMortgagePropertyState?, action: Action) -> ResourceMortgagePropertyState {
    var state = state ?? ResourceMortgagePropertyState()
    
    switch action {
    case let action as cpuMoneyAction:
        if let balanceDouble = action.balance.components(separatedBy: " ")[0].toDouble(), let cpuMoneyDouble = action.cpuMoney.toDouble(), let netMoneyDouble = action.netMoney.toDouble() {
            var valid = false
            var tips = R.string.localizable.big_money.key.localized()
            if balanceDouble >= cpuMoneyDouble + netMoneyDouble {
                valid = true
                tips = ""
            }
            
            if cpuMoneyDouble < (1 / pow(10, AppConfiguration.EOS_PRECISION)).doubleValue,action.cpuMoney != "",netMoneyDouble == 0 {
                valid = false
                if action.netMoney != "" {
                    tips = R.string.localizable.delegate_not_all0.key.localized()
                } else {
                    tips = R.string.localizable.small_money.key.localized()
                }
            }
            
            state.cpuMoneyValid.accept((valid,tips,action.cpuMoney))
        }
    case let action as netMoneyAction:
        if let balanceDouble = action.balance.components(separatedBy: " ")[0].toDouble(), let cpuMoneyDouble = action.cpuMoney.toDouble(), let netMoneyDouble = action.netMoney.toDouble() {
            var valid = false
            var tips = R.string.localizable.big_money.key.localized()
            if balanceDouble >= cpuMoneyDouble + netMoneyDouble {
                valid = true
                tips = ""
            }
            
            if netMoneyDouble < (1 / pow(10, AppConfiguration.EOS_PRECISION)).doubleValue,action.netMoney != "",cpuMoneyDouble == 0 {
                valid = false
                if action.cpuMoney != "" {
                    tips = R.string.localizable.delegate_not_all0.key.localized()
                } else {
                    tips = R.string.localizable.small_money.key.localized()
                }
            }
            
            state.netMoneyValid.accept((valid,tips,action.netMoney))
        }
    case let action as cpuReliveMoneyAction:
        if let balanceDouble = action.balance.components(separatedBy: " ")[0].toDouble(), let cpuMoneyDouble = action.cpuMoney.toDouble(), let netMoneyDouble = action.netMoney.toDouble() {
            var valid = false
            var tips = R.string.localizable.big_money.key.localized()
            if balanceDouble >= cpuMoneyDouble {
                valid = true
                tips = ""
            }
            
            if cpuMoneyDouble < (1 / pow(10, AppConfiguration.EOS_PRECISION)).doubleValue,action.cpuMoney != "",netMoneyDouble == 0 {
                valid = false
                if action.netMoney != "" {
                    tips = R.string.localizable.delegate_not_all0.key.localized()
                } else {
                    tips = R.string.localizable.small_money.key.localized()
                }
            }
            
            state.cpuReliveMoneyValid.accept((valid,tips,action.cpuMoney))
        }
    case let action as netReliveMoneyAction:
        if let balanceDouble = action.balance.components(separatedBy: " ")[0].toDouble(), let cpuMoneyDouble = action.cpuMoney.toDouble(), let netMoneyDouble = action.netMoney.toDouble() {
            var valid = false
            var tips = R.string.localizable.big_money.key.localized()
            if balanceDouble >= netMoneyDouble {
                valid = true
                tips = ""
            }
            
            if netMoneyDouble < (1 / pow(10, AppConfiguration.EOS_PRECISION)).doubleValue,action.netMoney != "",cpuMoneyDouble == 0 {
                valid = false
                if action.cpuMoney != "" {
                    tips = R.string.localizable.delegate_not_all0.key.localized()
                } else {
                    tips = R.string.localizable.small_money.key.localized()
                }
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
    case let action as AccountFetchedFromLocalAction:
        let viewmodel = initViewModel()

        if action.model != nil {
            let viewmodel = convertToViewModelWithModel(model: action.model!, viewmodel:viewmodel)
            state.info.accept(viewmodel)
        } else {
            state.info.accept(viewmodel)
        }
        

    default:
        break
    }
    
    return state
}

func initViewModel() -> ResourceViewModel {
    let newViewModel = ResourceViewModel(general: [GeneralViewModel(name: R.string.localizable.cpu.key.localized(), eos: "- EOS", leftSub: R.string.localizable.use.key.localized() + " - " + R.string.localizable.ms.key.localized(), rightSub: R.string.localizable.total.key.localized() + " - " + R.string.localizable.ms.key.localized(), lineHidden: false, progress: 0.0),GeneralViewModel(name: R.string.localizable.net.key.localized(), eos: "- EOS", leftSub: R.string.localizable.use.key.localized() + " - " + R.string.localizable.kb.key.localized(), rightSub: R.string.localizable.total.key.localized() + " - " + R.string.localizable.kb.key.localized(), lineHidden: true, progress: 0.0)], page: PageViewModel(balance: "- EOS", leftText: R.string.localizable.mortgage_resource.key.localized(), rightText: R.string.localizable.cancel_mortgage.key.localized(), operationLeft: [OperationViewModel(title: R.string.localizable.mortgage_cpu.key.localized(), placeholder: R.string.localizable.mortgage_placeholder.key.localized(), warning: "", introduce: "", isShowPromptWhenEditing: true, showLine: true, isSecureTextEntry: false),OperationViewModel(title: R.string.localizable.mortgage_net.key.localized(), placeholder: R.string.localizable.mortgage_placeholder.key.localized(), warning: "", introduce: "", isShowPromptWhenEditing: true, showLine: false, isSecureTextEntry: false)], operationRight: [OperationViewModel(title: R.string.localizable.cpu.key.localized(), placeholder: R.string.localizable.mortgage_cancel_placeholder.key.localized(), warning: "", introduce: "", isShowPromptWhenEditing: true, showLine: true, isSecureTextEntry: false),OperationViewModel(title: R.string.localizable.net.key.localized(), placeholder: R.string.localizable.mortgage_cancel_placeholder.key.localized(), warning: "", introduce: "", isShowPromptWhenEditing: true, showLine: false, isSecureTextEntry: false)]))
    return newViewModel
}

func convertResourceViewModelWithAccount(_ account:Account, viewmodel:ResourceViewModel?) -> ResourceViewModel {
    if var newViewModel = viewmodel {
        newViewModel.general[0].eos = account.total_resources?.cpu_weight ?? "- \(NetworkConfiguration.EOSIO_DEFAULT_SYMBOL)"
        newViewModel.general[1].eos = account.total_resources?.net_weight ?? "- \(NetworkConfiguration.EOSIO_DEFAULT_SYMBOL)"
        if let used = account.cpu_limit?.used,let max = account.cpu_limit?.max {
            
            newViewModel.general[0].leftSub = R.string.localizable.use.key.localized() + " \(used.toMS) " + R.string.localizable.ms.key.localized()
            newViewModel.general[0].rightSub = R.string.localizable.total.key.localized() + " \(max.toMS) " + R.string.localizable.ms.key.localized()
            newViewModel.general[0].progress = used.toMS.float()! / max.toMS.float()!
        }
        if let used = account.net_limit?.used,let max = account.net_limit?.max  {
            newViewModel.general[1].leftSub = R.string.localizable.use.key.localized() + " \(used.toKB) " + R.string.localizable.kb.key.localized()
            newViewModel.general[1].rightSub = R.string.localizable.total.key.localized() + " \(max.toKB) " + R.string.localizable.kb.key.localized()
            newViewModel.general[1].progress = used.toKB.float()! / max.toKB.float()!
        }
        return newViewModel
    } else {
        var newViewModel = initViewModel()
        newViewModel = convertResourceViewModelWithAccount(account, viewmodel: newViewModel)
        return newViewModel
    }
}

func convertToViewModelWithModel(model: AccountModel, viewmodel:ResourceViewModel?) -> ResourceViewModel {
    if var newViewModel = viewmodel {
        newViewModel.general[0].eos = model.cpu_weight ?? "- \(NetworkConfiguration.EOSIO_DEFAULT_SYMBOL)"
        newViewModel.general[1].eos = model.net_weight ?? "- \(NetworkConfiguration.EOSIO_DEFAULT_SYMBOL)"
        if let used = model.cpu_used,let max = model.cpu_max {
            newViewModel.general[0].leftSub = R.string.localizable.use.key.localized() + " \(used.toMS) " + R.string.localizable.ms.key.localized()
            newViewModel.general[0].rightSub = R.string.localizable.total.key.localized() + " \(max.toMS) " + R.string.localizable.ms.key.localized()
            newViewModel.general[0].progress = used.toMS.float()! / max.toMS.float()!
        }
        if let used = model.net_used,let max = model.net_max  {
            newViewModel.general[1].leftSub = R.string.localizable.use.key.localized() + " \(used.toKB) " + R.string.localizable.kb.key.localized()
            newViewModel.general[1].rightSub = R.string.localizable.total.key.localized() + " \(max.toKB) " + R.string.localizable.kb.key.localized()
            newViewModel.general[1].progress = used.toKB.float()! / max.toKB.float()!
        }
        
        if let balance = Defaults[model.account_name + NetworkConfiguration.BALANCE_DEFAULT_SYMBOL] as? String {
            newViewModel.page.balance = balance
        }
        return newViewModel
    }
    return viewmodel!
}


