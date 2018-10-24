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
import SwiftyUserDefaults

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
        }
//        else {
//            let viewmodel = initAccountViewModel()
//            state.info.accept(viewmodel)
//        }
    case let action as AccountFetchedAction:
        if action.info != nil {
            var viewmodel = convertAccountViewModelWithAccount(action.info!, viewmodel:state.info.value)
            viewmodel.CNY = calculateRMBPrice(viewmodel, price:state.CNY_price, otherPrice: state.Other_price)
            
            state.info.accept(viewmodel)
        }
//        else {
//            let viewmodel = initAccountViewModel()
//            state.info.accept(viewmodel)
//        }
    case let action as RMBPriceFetchedAction:
        if action.price != nil {
            var viewmodel = state.info.value
            state.CNY_price = action.price!["value"].stringValue
            if action.otherPrice != nil {
                state.Other_price = action.otherPrice!["value"].stringValue
            }
            
            viewmodel.CNY = calculateRMBPrice(viewmodel, price:state.CNY_price, otherPrice: state.Other_price)
            state.info.accept(viewmodel)
        }
//        else {
//            let viewmodel = initAccountViewModel()
//            state.info.accept(viewmodel)
//        }
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


func convertToViewModelWithModel(model: AccountModel) -> AccountViewModel {
    var viewModel = AccountViewModel()
    viewModel.account = model.account_name
    viewModel.portrait = model.account_name.sha256()
    viewModel.cpuValue = model.delegate_cpu_weight ?? "- \(NetworkConfiguration.EOSIO_DEFAULT_SYMBOL)"
    viewModel.netValue = model.delegate_net_weight ?? "- \(NetworkConfiguration.EOSIO_DEFAULT_SYMBOL)"
    viewModel.ramValue = model.ram_bytes != nil ? model.ram_bytes.ramCount : ""
    viewModel.cpuProgress = Float(model.cpu_used) / Float(model.cpu_max)
    viewModel.netProgress = Float(model.net_used) / Float(model.net_max)
    viewModel.ramProgress = Float(model.ram_usage) / Float(model.ram_quota)
    if let balance = Defaults[model.account_name + NetworkConfiguration.BALANCE_DEFAULT_SYMBOL] as? String {
        viewModel.balance = balance
    }
    viewModel.allAssets = calculateTotalAsset(viewModel)
    if let rmbUnit = Defaults[Unit.RMB_UNIT] as? String, let usdUnit = Defaults[Unit.USD_UNIT] as? String {
        viewModel.CNY = calculateRMBPrice(viewModel, price: rmbUnit, otherPrice: usdUnit)
    }

    return viewModel
}


