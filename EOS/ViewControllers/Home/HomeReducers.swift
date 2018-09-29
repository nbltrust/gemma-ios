//
//  HomeReducers.swift
//  EOS
//
//  Created koofrank on 2018/7/4.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift
import CryptoSwift

func HomeReducer(action:Action, state:HomeState?) -> HomeState {
    return HomeState(isLoading: loadingReducer(state?.isLoading, action: action), page: pageReducer(state?.page, action: action), errorMessage: errorMessageReducer(state?.errorMessage, action: action), property: HomePropertyReducer(state?.property, action: action))
}

func HomePropertyReducer(_ state: HomePropertyState?, action: Action) -> HomePropertyState {
    var state = state ?? HomePropertyState()
    
    switch action {
    case let action as BalanceFetchedAction:

        if action.balance != nil {
            var viewmodel = state.info.value

            if let balance = action.balance?.arrayValue.first?.string {
                viewmodel.balance = balance
            }
            else {
                viewmodel.balance = "- \(NetworkConfiguration.EOSIO_DEFAULT_SYMBOL)"
            }
            
            viewmodel.allAssets = calculateTotalAsset(viewmodel)
            viewmodel.CNY = calculateRMBPrice(viewmodel, price:state.CNY_price, otherPrice: state.Other_price)
            state.info.accept(viewmodel)
        } else {
            let viewmodel = initAccountViewModel()
            state.info.accept(viewmodel)
        }
    case let action as AccountFetchedAction:
        if action.info != nil {
            var viewmodel = convertAccountViewModelWithAccount(action.info!, viewmodel:state.info.value)
            viewmodel.CNY = calculateRMBPrice(viewmodel, price:state.CNY_price, otherPrice: state.Other_price)
            
            state.info.accept(viewmodel)
        } else {
            let viewmodel = initAccountViewModel()
            state.info.accept(viewmodel)
        }
    case let action as RMBPriceFetchedAction:
        if action.price != nil {
            var viewmodel = state.info.value
            state.CNY_price = action.price!["value"].stringValue
            if action.otherPrice != nil {
                state.Other_price = action.otherPrice!["value"].stringValue
            }
            
            viewmodel.CNY = calculateRMBPrice(viewmodel, price:state.CNY_price, otherPrice: state.Other_price)
            state.info.accept(viewmodel)
        } else {
            let viewmodel = initAccountViewModel()
            state.info.accept(viewmodel)
        }
    case let action as AccountFetchedFromLocalAction:
        if action.model != nil {
            let viewmodel = convertToViewModelWithModel(model: action.model!)
//            viewmodel.CNY = calculateRMBPrice(viewmodel, price:state.CNY_price, otherPrice: state.Other_price)
            
            state.model.accept(viewmodel)
        } else {
            let viewmodel = initAccountViewModel()
            state.info.accept(viewmodel)
        }
    default:
        break
    }
    
    return state
}

func initAccountViewModel() -> AccountViewModel {
    var newViewModel = AccountViewModel()
    newViewModel.account = "--"
    newViewModel.portrait = ""
    newViewModel.cpuValue = "- \(NetworkConfiguration.EOSIO_DEFAULT_SYMBOL)"
    newViewModel.netValue = "- \(NetworkConfiguration.EOSIO_DEFAULT_SYMBOL)"
    
    newViewModel.cpuProgress = 0
    newViewModel.netProgress = 0
    newViewModel.ramProgress = 0
    
    newViewModel.ramValue = "- \(NetworkConfiguration.EOSIO_DEFAULT_SYMBOL)"
    
    newViewModel.recentRefundAsset = "- \(NetworkConfiguration.EOSIO_DEFAULT_SYMBOL)"

    newViewModel.refundTime = ""
    
    newViewModel.allAssets = calculateTotalAsset(newViewModel)
    
    return newViewModel
}

func convertAccountViewModelWithAccount(_ account:Account, viewmodel:AccountViewModel) -> AccountViewModel {
    saveToLocal(account)
    var newViewModel = viewmodel
    newViewModel.account = account.account_name
    newViewModel.portrait = account.account_name.sha256()
    newViewModel.cpuValue = account.self_delegated_bandwidth?.cpu_weight ?? "- \(NetworkConfiguration.EOSIO_DEFAULT_SYMBOL)"
    newViewModel.netValue = account.self_delegated_bandwidth?.net_weight ?? "- \(NetworkConfiguration.EOSIO_DEFAULT_SYMBOL)"
    
    if let used = account.cpu_limit?.used.string,let max = account.cpu_limit?.max.string {
        newViewModel.cpuProgress = used.float()! / max.float()!
    }
    if let used = account.net_limit?.used.string,let max = account.net_limit?.max.string  {
        newViewModel.netProgress = used.float()! / max.float()!
    }
    newViewModel.ramProgress = Float(account.ram_usage) / Float(account.ram_quota)
    
    if let ram = account.total_resources?.ram_bytes {
        newViewModel.ramValue = ram.ramCount
    }
    else {
        newViewModel.ramValue = "- \(NetworkConfiguration.EOSIO_DEFAULT_SYMBOL)"
    }
    
    if let refund_net = account.refund_request?.net_amount.eosAmount.toDouble(), let refund_cpu = account.refund_request?.cpu_amount.eosAmount.toDouble() {
        let asset = refund_cpu + refund_net
        newViewModel.recentRefundAsset = "\(asset.string(digits: AppConfiguration.EOS_PRECISION)) \(NetworkConfiguration.EOSIO_DEFAULT_SYMBOL)"
    }
    else {
        newViewModel.recentRefundAsset = "- \(NetworkConfiguration.EOSIO_DEFAULT_SYMBOL)"
    }
    
    if let date = account.refund_request?.request_time {
        newViewModel.refundTime = date.refundStatus
    }
    else {
        newViewModel.refundTime = ""
    }
    
    newViewModel.allAssets = calculateTotalAsset(newViewModel)
    
    return newViewModel
}

func calculateTotalAsset(_ viewmodel:AccountViewModel) -> String {
    if let balance = viewmodel.balance.eosAmount.toDouble(), let cpu = viewmodel.cpuValue.eosAmount.toDouble(),
        let net = viewmodel.netValue.eosAmount.toDouble() {
        let total = balance + cpu + net
        
        return total.string(digits: AppConfiguration.EOS_PRECISION) + " \(NetworkConfiguration.EOSIO_DEFAULT_SYMBOL)"
    }
    else {
        return "- \(NetworkConfiguration.EOSIO_DEFAULT_SYMBOL)"
    }
}

func calculateRMBPrice(_ viewmodel:AccountViewModel, price:String, otherPrice:String) -> String {
    if let unit = price.toDouble(), unit != 0, let all = viewmodel.allAssets.eosAmount.toDouble(), all != 0 {
        let cny = unit * all
        if coinType() == .CNY {
            return "≈" + cny.string(digits: 2) + " \(coinUnit())"
        } else {
            if let otherPriceDouble = otherPrice.toDouble() {
                return "≈" + (cny / otherPriceDouble).string(digits: 2) + " \(coinUnit())"
            } else {
                return "≈- \(coinUnit())"
            }
        }
    }
    else {
        return "≈- \(coinUnit())"
    }
}

func saveToLocal(_ account:Account) {
    var accountModel = AccountModel()
    accountModel.account_name = account.account_name
    accountModel.net_weight = account.total_resources?.net_weight
    accountModel.cpu_weight = account.total_resources?.cpu_weight
    accountModel.ram_bytes = account.total_resources?.ram_bytes
    accountModel.from = account.self_delegated_bandwidth?.from
    accountModel.to = account.self_delegated_bandwidth?.to
    accountModel.delegate_net_weight = account.self_delegated_bandwidth?.net_weight
    accountModel.delegate_cpu_weight = account.self_delegated_bandwidth?.cpu_weight
    accountModel.request_time = account.refund_request?.request_time
    accountModel.net_amount = account.refund_request?.net_amount
    accountModel.cpu_amount = account.refund_request?.cpu_amount
    accountModel.net_used = account.net_limit?.used
    accountModel.net_available = account.net_limit?.available
    accountModel.net_max = account.net_limit?.max
    accountModel.cpu_used = account.cpu_limit?.used
    accountModel.cpu_available = account.cpu_limit?.available
    accountModel.cpu_max = account.cpu_limit?.max
    accountModel.ram_quota = account.ram_quota
    accountModel.ram_usage = account.ram_usage
    accountModel.created = account.created
    accountModel.save()
}

func convertToViewModelWithModel(model: AccountModel) -> AccountViewModel {
    var viewModel = AccountViewModel()
    viewModel.account = model.account_name
    viewModel.portrait = model.account_name.sha256()
    viewModel.allAssets = calculateTotalAsset(viewModel)
    viewModel.cpuValue = model.delegate_cpu_weight ?? "- \(NetworkConfiguration.EOSIO_DEFAULT_SYMBOL)"
    viewModel.netValue = model.delegate_net_weight ?? "- \(NetworkConfiguration.EOSIO_DEFAULT_SYMBOL)"
    viewModel.ramValue = model.ram_bytes.ramCount ?? "- \(NetworkConfiguration.EOSIO_DEFAULT_SYMBOL)"
    viewModel.cpuProgress = Float(model.cpu_used / model.cpu_max)
    viewModel.netProgress = Float(model.net_used / model.net_max)
    viewModel.ramProgress = Float(model.ram_usage / model.ram_quota)

    return viewModel
}

func saveBalanceToLocal(balance: String) {
    var condition = DataFetchCondition()
    condition.key = "account_name"
    condition.value = ""
    condition.check = .equal
    do {
        let data = try DataProvider.shared.selectData("AccountModel", valueConditon: condition)
        
    }
    catch {
        
    }
}
