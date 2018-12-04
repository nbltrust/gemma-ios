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
        if let currency = action.currency {
            if currency.type == .EOS {
                if let balance = action.balance?.arrayValue.first?.string {
                    viewmodel.balance = balance
                } else {
                    viewmodel.balance = "0.0000 \(NetworkConfiguration.EOSIODefaultSymbol)"
                }
                viewmodel.allAssets = calculateTotalAsset(viewmodel)
                viewmodel.CNY = calculateRMBPrice(viewmodel, price: state.cnyPrice, otherPrice: state.otherPrice)
            } else if currency.type == .ETH {

            }
        }
        state.info.accept(viewmodel)
    case let action as AccountFetchedAction:
        var viewmodel = NewHomeViewModel()
        if let currency = action.currency {
            if currency.type == .EOS {
                if let info = action.info {
                    viewmodel = convertViewModelWithAccount(info, viewmodel: state.info.value, currencyID: currency.id)
                    viewmodel.CNY = calculateRMBPrice(viewmodel, price: state.cnyPrice, otherPrice: state.otherPrice)
                }
            } else if currency.type == .ETH {

            }
        }
        state.info.accept(viewmodel)
    case let action as RMBPriceFetchedAction:
        var viewmodel = state.info.value
        if action.currency != nil {
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
    case let action as TokensFetchedAction:
        if state.info.value != nil {
            var viewmodel = state.info.value
            viewmodel = setTokenWith(tokens: action.data, viewmodel: viewmodel)
            state.info.accept(viewmodel)
        } else {
            var viewmodel = NewHomeViewModel()
            viewmodel = setTokenWith(tokens: action.data, viewmodel: viewmodel)
            state.info.accept(viewmodel)
        }
    case let action as DoActiveFetchedAction:
        let viewmodel = setViewModelWithCurrency(currency: action.currency, actions: action.actions)
        state.info.accept(viewmodel)
    default:
        break
    }

    return state
}

func setTokenWith(tokens: [Tokens], viewmodel: NewHomeViewModel) -> NewHomeViewModel {
    var newViewModel = viewmodel
    newViewModel.tokens = "\(tokens.count-1)"
    var array: [String] = []
    for token in tokens {
        if token.symbol != "EOS" {
            array.append(token.logoUrl)
        }
    }
    newViewModel.tokenArray = array
    return newViewModel
}

func setViewModelWithCurrency(currency: Currency?, actions: Actions? = nil) -> NewHomeViewModel {
    var viewmodel = NewHomeViewModel()
    viewmodel.currencyImg = R.image.eosBg()!
    viewmodel.account = R.string.localizable.wait_activate.key.localized()
    if let currencyId = currency?.id, CurrencyManager.shared.getActived(currencyId) == .actived {
        if let accountName = CurrencyManager.shared.getAccountNameWith(currencyId) {
            viewmodel.account = accountName
        }
    } else if let currencyId = currency?.id, CurrencyManager.shared.getActived(currencyId) == .doActive {
        if let block = actions?.blockNum, let lib = actions?.lastIrreversibleBlock {
            viewmodel.account = R.string.localizable.account_creation.key.localized() + "\((1 - (block - lib)/325)*100)%"
        } else {
            viewmodel.account = R.string.localizable.account_creation.key.localized() + "0%"
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
    newViewModel.cpuValue = account.selfDelegatedBandwidth?.cpuWeight ?? "0.0000 \(NetworkConfiguration.EOSIODefaultSymbol)"
    newViewModel.netValue = account.selfDelegatedBandwidth?.netWeight ?? "0.0000 \(NetworkConfiguration.EOSIODefaultSymbol)"
    if let ram = account.totalResources?.ramBytes {
        newViewModel.ramValue = ram.ramCount
    } else {
        newViewModel.ramValue = "0.0000 \(NetworkConfiguration.EOSIODefaultSymbol)"
    }

    if let used = account.cpuLimit?.used.string, let max = account.cpuLimit?.max.string {
        newViewModel.cpuProgress = used.float()! / max.float()!
    }
    if let used = account.netLimit?.used.string, let max = account.netLimit?.max.string {
        newViewModel.netProgress = used.float()! / max.float()!
    }
    newViewModel.ramProgress = Float(account.ramUsage) / Float(account.ramQuota)
    if let refundNet = account.refundRequest?.netAmount.eosAmount.toDecimal(), let refundCpu = account.refundRequest?.cpuAmount.eosAmount.toDecimal() {
        let asset = refundCpu + refundNet
        newViewModel.recentRefundAsset = "\(asset.string(digits: AppConfiguration.EOSPrecision)) \(NetworkConfiguration.EOSIODefaultSymbol)"
    } else {
        newViewModel.recentRefundAsset = "0.0000 \(NetworkConfiguration.EOSIODefaultSymbol)"
    }

    newViewModel.allAssets = calculateTotalAsset(newViewModel)
    newViewModel.currency = "EOS"
    newViewModel.unit = "EOS"
    newViewModel.id = currencyID ?? 0
    return newViewModel
}

func calculateTotalAsset(_ viewmodel: NewHomeViewModel) -> String {
    if let balance = viewmodel.balance.eosAmount.toDecimal(), let cpu = viewmodel.cpuValue.eosAmount.toDecimal(),
        let net = viewmodel.netValue.eosAmount.toDecimal() {
        let total = balance + cpu + net

        return total.string(digits: AppConfiguration.EOSPrecision)
    } else {
        return "0.0000"
    }
}

func calculateRMBPrice(_ viewmodel: NewHomeViewModel, price: String, otherPrice: String) -> String {
    if let unit = price.toDecimal(), unit != 0, let all = viewmodel.allAssets.toDecimal(), all != 0 {
        let cny = unit * all
        if coinType() == .CNY {
            return cny.formatCurrency(digitNum: 2)
        } else {
            if let otherPriceDouble = otherPrice.toDecimal() {
                return (cny / otherPriceDouble).formatCurrency(digitNum: 2)
            } else {
                return "0.00"
            }
        }
    } else {
        return "0.00"
    }
}
