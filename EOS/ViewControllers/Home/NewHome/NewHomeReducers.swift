//
//  NewHomeReducers.swift
//  EOS
//
//  Created zhusongyu on 2018/10/17.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift
import SwiftyUserDefaults

func gNewHomeReducer(action: Action, state: NewHomeState?) -> NewHomeState {
    var state = state ?? NewHomeState()

    switch action {
    case let action as BalanceFetchedAction:
        var viewmodel = state.info.value
        if action.currencyID != nil {
            if let json = CurrencyManager.shared.getBalanceJsonWith(action.currencyID) {
                if let balance = json.arrayValue.first?.string {
                    viewmodel.balance = balance
                } else {
                    viewmodel.balance = "- \(NetworkConfiguration.EOSIODefaultSymbol)"
                }
                viewmodel.allAssets = calculateTotalAsset(viewmodel)
                viewmodel.CNY = calculateRMBPrice(viewmodel, price: state.cnyPrice, otherPrice: state.otherPrice)
            }
        }
        state.info.accept(viewmodel)
    case let action as AccountFetchedAction:
        var viewmodel = NewHomeViewModel()
        if action.currencyID != nil {
            if let json = CurrencyManager.shared.getAccountJsonWith(action.currencyID), let accountObj = Account.deserialize(from: json.dictionaryObject) {
                viewmodel = convertViewModelWithAccount(accountObj, viewmodel: state.info.value, currencyID: action.currencyID)
                viewmodel.CNY = calculateRMBPrice(viewmodel, price: state.cnyPrice, otherPrice: state.otherPrice)
            }
        }
        state.info.accept(viewmodel)
    case let action as RMBPriceFetchedAction:
        var viewmodel = state.info.value
        if action.currencyID != nil {
            if coinType() == .CNY, let eos = CurrencyManager.shared.getCNYPrice() {
                state.cnyPrice = eos
            } else if coinType() == .USD, let usd = CurrencyManager.shared.getUSDPrice() {
                state.otherPrice = usd
            }
        }
        viewmodel.CNY = calculateRMBPrice(viewmodel, price: state.cnyPrice, otherPrice: state.otherPrice)
        state.info.accept(viewmodel)
    case let action as NonActiveFetchedAction:
        let viewmodel = setViewModelWithCurrency(currency: action.currency)
        state.info.accept(viewmodel)
    default:
        break
    }

    return state
}

func setViewModelWithCurrency(currency: Currency?) -> NewHomeViewModel {
    var viewmodel = NewHomeViewModel()
    viewmodel.currencyImg = R.image.eosBg()!
    viewmodel.account = R.string.localizable.wait_activate.key.localized()
    if let id = currency?.id {
        if let accountName = CurrencyManager.shared.getAccountNameWith(id) {
            viewmodel.account = accountName
        }
    }
    viewmodel.CNY = "0.00"
    if currency?.type == .EOS {
        viewmodel.currency = "EOS"
        viewmodel.unit = "EOS"
    } else if currency?.type == .ETH {
        viewmodel.currency = "ETH"
        viewmodel.unit = "ETH"
    }
    viewmodel.allAssets = 0.string(digits: AppConfiguration.EOSPrecision)
    viewmodel.id = currency?.id ?? 0
    
    return viewmodel
}

func convertViewModelWithAccount(_ account: Account, viewmodel: NewHomeViewModel, currencyID: Int64?) -> NewHomeViewModel {
    var newViewModel = viewmodel
    newViewModel.currencyImg = R.image.eosBg()!
    newViewModel.account = account.accountName
    newViewModel.cpuValue = account.selfDelegatedBandwidth?.cpuWeight ?? "- \(NetworkConfiguration.EOSIODefaultSymbol)"
    newViewModel.netValue = account.selfDelegatedBandwidth?.netWeight ?? "- \(NetworkConfiguration.EOSIODefaultSymbol)"
    if let ram = account.totalResources?.ramBytes {
        newViewModel.ramValue = ram.ramCount
    } else {
        newViewModel.ramValue = "- \(NetworkConfiguration.EOSIODefaultSymbol)"
    }
    newViewModel.allAssets = calculateTotalAsset(newViewModel)
    newViewModel.currency = "EOS"
    newViewModel.unit = "EOS"
    newViewModel.id = currencyID ?? 0
    return newViewModel
}

func calculateTotalAsset(_ viewmodel: NewHomeViewModel) -> String {
    if let balance = viewmodel.balance.eosAmount.toDouble(), let cpu = viewmodel.cpuValue.eosAmount.toDouble(),
        let net = viewmodel.netValue.eosAmount.toDouble() {
        let total = balance + cpu + net

        return total.string(digits: AppConfiguration.EOSPrecision)
    } else {
        return "0.0000"
    }
}

func calculateRMBPrice(_ viewmodel: NewHomeViewModel, price: String, otherPrice: String) -> String {
    if let unit = price.toDouble(), unit != 0, let all = viewmodel.allAssets.eosAmount.toDouble(), all != 0 {
        let cny = unit * all
        if coinType() == .CNY {
            return cny.string(digits: 2)
        } else {
            if let otherPriceDouble = otherPrice.toDouble() {
                return (cny / otherPriceDouble).string(digits: 2)
            } else {
                return "0.00"
            }
        }
    } else {
        return "0.00"
    }
}
