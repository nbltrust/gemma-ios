//
//  BuyRamReducers.swift
//  EOS
//
//  Created zhusongyu on 2018/8/9.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift
import SwiftyUserDefaults

func BuyRamReducer(action:Action, state:BuyRamState?) -> BuyRamState {
    return BuyRamState(isLoading: loadingReducer(state?.isLoading, action: action), page: pageReducer(state?.page, action: action), errorMessage: errorMessageReducer(state?.errorMessage, action: action), property: BuyRamPropertyReducer(state?.property, action: action), callback:state?.callback ?? BuyRamCallbackState())
}

func BuyRamPropertyReducer(_ state: BuyRamPropertyState?, action: Action) -> BuyRamPropertyState {
    var state = state ?? BuyRamPropertyState()
    
    switch action {
    case let action as BuyRamAction:
        if let balanceDouble = action.balance.components(separatedBy: " ")[0].toDouble(), let cpuMoneyDouble = action.ram.toDouble() {
            var valid = false
            var tips = R.string.localizable.big_money.key.localized()
            if balanceDouble >= cpuMoneyDouble {
                valid = true
                tips = ""
            }
            
            if cpuMoneyDouble < (1 / pow(10, AppConfiguration.EOS_PRECISION)).doubleValue,action.ram != "" {
                valid = false
                tips = R.string.localizable.small_money.key.localized()
            }
            
            if action.ram == "" {
                valid = false
            }
            
            state.buyRamValid.accept((valid,tips,action.ram))
        }
    case let action as SellRamAction:
        if let balanceDouble = action.balance.components(separatedBy: " ")[0].toDouble(), let cpuMoneyDouble = action.ram.toDouble() {
            var valid = false
            var tips = R.string.localizable.big_money.key.localized()
            if balanceDouble >= cpuMoneyDouble {
                valid = true
                tips = ""
            }
            
            if cpuMoneyDouble < (1 / pow(10, AppConfiguration.EOS_PRECISION)).doubleValue,action.ram != "" {
                valid = false
                tips = R.string.localizable.small_money.key.localized()
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
                    viewmodel.exchange = R.string.localizable.exchange_pre.key.localized() + exchangeStr + " KB"
                } else {
                    let exchangeStr = (amountDecimal * viewmodel.price).doubleValue.string(digits: 3)
                    viewmodel.exchange = R.string.localizable.exchange_pre.key.localized() + exchangeStr + " EOS"
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
                    viewmodel.exchange = R.string.localizable.exchange_pre.key.localized() + exchangeStr + " KB"
                } else {
                    let exchangeStr = (amountDecimal * viewmodel.price).doubleValue.string(digits: 3)
                    viewmodel.exchange = R.string.localizable.exchange_pre.key.localized() + exchangeStr + " EOS"
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
    case let action as AccountFetchedFromLocalAction:
        var viewmodel = state.info.value
        if let model = action.model {
            viewmodel = convertToViewModelWithModel(model: model, viewmodel:viewmodel)
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
        newViewModel.leftSub = R.string.localizable.use.key.localized() + " \(used) " + R.string.localizable.kb.key.localized()
        newViewModel.rightSub = R.string.localizable.total.key.localized() + " \(max) " + R.string.localizable.kb.key.localized()
        newViewModel.progress = used.float()! / max.float()!
       
        newViewModel.rightTrade = (max.float()! - used.float()!).string + " " + R.string.localizable.kb.key.localized()
        
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

func convertToViewModelWithModel(model: AccountModel, viewmodel:BuyRamViewModel?) -> BuyRamViewModel {
    if var newViewModel = viewmodel {
        let used = model.ram_usage.toKB
        let max = model.ram_quota.toKB
        newViewModel.leftSub = R.string.localizable.use.key.localized() + " \(used) " + R.string.localizable.kb.key.localized()
        newViewModel.rightSub = R.string.localizable.total.key.localized() + " \(max) " + R.string.localizable.kb.key.localized()
        newViewModel.progress = used.float()! / max.float()!
        
        newViewModel.rightTrade = (max.float()! - used.float()!).string + " " + R.string.localizable.kb.key.localized()
        
        if let cpu_max = model.cpu_max {
            newViewModel.cpu_max = cpu_max
        }
        if let net_max = model.net_max {
            newViewModel.net_max = net_max
        }
        
        if let balance = Defaults[model.account_name + NetworkConfiguration.BALANCE_DEFAULT_SYMBOL] as? String {
            newViewModel.leftTrade = balance
        }
        
        if let ramPrice = Defaults[NetworkConfiguration.RAMPRICE_DEFAULT_SYMBOL] as? String {
            let price = Decimal(string: ramPrice)! * 1024
            newViewModel.price = price
            newViewModel.priceLabel = "≈" + price.doubleValue.string(digits: 8) + " EOS/KB"
        }
        return newViewModel
    } else {
        var newViewModel = BuyRamViewModel()
        newViewModel = convertToViewModelWithModel(model:model, viewmodel: newViewModel)
        return newViewModel
    }
}

