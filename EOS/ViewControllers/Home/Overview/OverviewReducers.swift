//
//  OverviewReducers.swift
//  EOS
//
//  Created zhusongyu on 2018/10/30.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift

func gOverviewReducer(action:Action, state:OverviewState?) -> OverviewState {
    var state = state ?? OverviewState()
        
    switch action {
    case let action as MBalanceFetchedAction:
        if var viewmodel = state.info.value {
            if let balance = action.balance.arrayValue.first?.string {
                viewmodel.balance = balance
            } else {
                viewmodel.balance = "- \(NetworkConfiguration.EOSIODefaultSymbol)"
            }
            viewmodel.allAssets = calculateTotalAsset(viewmodel)
            viewmodel.CNY = calculateRMBPrice(viewmodel, price: state.cnyPrice, otherPrice: state.otherPrice)

            state.info.accept(viewmodel)
        } else {
            var viewmodel = NewHomeViewModel()
            viewmodel.bottomIsHidden = false
            if let balance = action.balance.arrayValue.first?.string {
                viewmodel.balance = balance
            } else {
                viewmodel.balance = "- \(NetworkConfiguration.EOSIODefaultSymbol)"
            }
            state.info.accept(viewmodel)
        }
    case let action as MAccountFetchedAction:
        if var viewmodel = state.info.value {
            viewmodel = convertViewModelWithAccount(action.info, viewmodel: viewmodel, currencyID: CurrencyManager.shared.getCurrentCurrencyID())
            viewmodel.CNY = calculateRMBPrice(viewmodel, price: state.cnyPrice, otherPrice: state.otherPrice)

            state.info.accept(viewmodel)
        } else {
            var viewmodel = NewHomeViewModel()
            viewmodel.bottomIsHidden = false
            viewmodel = convertViewModelWithAccount(action.info, viewmodel: viewmodel, currencyID: CurrencyManager.shared.getCurrentCurrencyID())
            state.info.accept(viewmodel)
        }
    case let action as RMBPriceFetchedAction:
        var viewmodel = state.info.value
        if coinType() == .CNY, let eos = CurrencyManager.shared.getCNYPrice() {
            state.cnyPrice = eos
        } else if coinType() == .USD, let usd = CurrencyManager.shared.getUSDPrice() {
            state.otherPrice = usd
        }
        if viewmodel != nil {
            viewmodel!.CNY = calculateRMBPrice(viewmodel!, price: state.cnyPrice, otherPrice: state.otherPrice)
        }
        state.info.accept(viewmodel)
    case let action as TokensFetchedAction:
        let model = convertViewModelWithAccount(tokensJson: action.data)
        state.tokens.accept(model)
    default:
        break
    }
        
    return state
}

func convertViewModelWithAccount(tokensJson: [Tokens]) -> [AssetViewModel] {
    var modelArray: [AssetViewModel] = []
    for token in tokensJson {
        var model = AssetViewModel()
        model.name = token.symbol
        model.total = token.totalValue
        model.iconUrl = token.logoUrl
        model.balance = token.balance
        model.contract = token.contract
        modelArray.append(model)
    }
    return modelArray
}
