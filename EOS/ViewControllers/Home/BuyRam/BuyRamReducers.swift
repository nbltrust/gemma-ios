//
//  BuyRamReducers.swift
//  EOS
//
//  Created zhusongyu on 2018/8/9.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift

func BuyRamReducer(action:Action, state:BuyRamState?) -> BuyRamState {
    return BuyRamState(isLoading: loadingReducer(state?.isLoading, action: action), page: pageReducer(state?.page, action: action), errorMessage: errorMessageReducer(state?.errorMessage, action: action), property: BuyRamPropertyReducer(state?.property, action: action), callback:state?.callback ?? BuyRamCallbackState())
}

func BuyRamPropertyReducer(_ state: BuyRamPropertyState?, action: Action) -> BuyRamPropertyState {
    var state = state ?? BuyRamPropertyState()
    
    switch action {
    case let action as BuyRamAction:
        if let balanceDouble = action.balance.components(separatedBy: " ")[0].toDouble(), let cpuMoneyDouble = action.ram.toDouble() {
            var valid = false
            var tips = R.string.localizable.big_money()
            if balanceDouble >= cpuMoneyDouble {
                valid = true
                tips = ""
            }
            
            if cpuMoneyDouble < (1 / pow(10, AppConfiguration.EOS_PRECISION)).doubleValue,action.ram != "" {
                valid = false
                tips = R.string.localizable.small_money()
            }
            
            if action.ram == "" {
                valid = false
            }
            
            state.buyRamValid.accept((valid,tips,action.ram))
        }
    case let action as SellRamAction:
        if let balanceDouble = action.balance.components(separatedBy: " ")[0].toDouble(), let cpuMoneyDouble = action.ram.toDouble() {
            var valid = false
            var tips = R.string.localizable.big_money()
            if balanceDouble >= cpuMoneyDouble {
                valid = true
                tips = ""
            }
            
            if cpuMoneyDouble < (1 / pow(10, AppConfiguration.EOS_PRECISION)).doubleValue,action.ram != "" {
                valid = false
                tips = R.string.localizable.small_money()
            }
            
            if action.ram == "" {
                valid = false
            }
            
            state.sellRamValid.accept((valid,tips,action.ram))
        }
    case let action as BBalanceFetchedAction:
        if var viewmodel = state.info.value {
            if let balance = action.balance.arrayValue.first?.string {
                viewmodel.leftTrade = balance
            }
            else {
                viewmodel.leftTrade = "- \(NetworkConfiguration.EOSIO_DEFAULT_SYMBOL)"
            }
            state.info.accept(viewmodel)
        } else {
            var viewmodel = BuyRamViewModel()
            if let balance = action.balance.arrayValue.first?.string {
                viewmodel.leftTrade = balance
            }
            else {
                viewmodel.leftTrade = "- \(NetworkConfiguration.EOSIO_DEFAULT_SYMBOL)"
            }
            state.info.accept(viewmodel)
        }
    case let action as ExchangeAction:
        if var viewmodel = state.info.value {
            if let amountDecimal = Decimal(string: action.amount) {
                if action.type == .left {
                    let exchangeStr = (amountDecimal / viewmodel.price).doubleValue.string(digits: 3)
                    viewmodel.exchange = R.string.localizable.exchange_pre() + exchangeStr + " KB"
                } else {
                    let exchangeStr = (amountDecimal * viewmodel.price).doubleValue.string(digits: 3)
                    viewmodel.exchange = R.string.localizable.exchange_pre() + exchangeStr + " EOS"
                }
            }
            if action.amount == "" {
                viewmodel.exchange = ""
            }
            
            state.info.accept(viewmodel)
        } else {
            var viewmodel = BuyRamViewModel()
            if let amountDecimal = Decimal(string: action.amount) {
                if action.type == .left {
                    let exchangeStr = (amountDecimal / viewmodel.price).doubleValue.string(digits: 3)
                    viewmodel.exchange = R.string.localizable.exchange_pre() + exchangeStr + " KB"
                } else {
                    let exchangeStr = (amountDecimal * viewmodel.price).doubleValue.string(digits: 3)
                    viewmodel.exchange = R.string.localizable.exchange_pre() + exchangeStr + " EOS"
                }
            }
            if action.amount == "" {
                viewmodel.exchange = ""
            }
            
            state.info.accept(viewmodel)
        }
    case let action as BAccountFetchedAction:
        var viewmodel = state.info.value
        viewmodel = convertBuyRamViewModelWithAccount(action.info, viewmodel:viewmodel)
        state.info.accept(viewmodel)
    case let action as RamPriceAction:
        if var viewmodel = state.info.value {
            let price = action.price * 1024
            viewmodel.price = price
            viewmodel.priceLabel = "≈" + price.doubleValue.string(digits: 8) + " EOS/KB"
            state.info.accept(viewmodel)
        } else {
            var viewmodel = BuyRamViewModel()
            let price = action.price * 1024
            viewmodel.price = price
            viewmodel.priceLabel = "≈" + price.doubleValue.string(digits: 8) + " EOS/KB"
            state.info.accept(viewmodel)
        }
    default:
        break
    }
    
    return state
}

func convertBuyRamViewModelWithAccount(_ account:Account, viewmodel:BuyRamViewModel?) -> BuyRamViewModel {
    if var newViewModel = viewmodel {
        let used = account.ram_usage.toKB
        let max = account.ram_quota.toKB
        newViewModel.leftSub = R.string.localizable.use() + " \(used) " + R.string.localizable.kb()
        newViewModel.rightSub = R.string.localizable.total() + " \(max) " + R.string.localizable.kb()
        newViewModel.progress = used.float()! / max.float()!
       
        newViewModel.rightTrade = (max.float()! - used.float()!).string + " " + R.string.localizable.kb()
        
        if let cpu_max = account.cpu_limit?.max {
            newViewModel.cpu_max = cpu_max
        }
        if let net_max = account.net_limit?.max {
            newViewModel.net_max = net_max
        }        
        return newViewModel
    } else {
        var newViewModel = BuyRamViewModel()
        newViewModel = convertBuyRamViewModelWithAccount(account, viewmodel: newViewModel)
        return newViewModel
    }
}


