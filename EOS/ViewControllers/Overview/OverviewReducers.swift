//
//  OverviewReducers.swift
//  EOS
//
//  Created zhusongyu on 2018/10/30.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift
import SwiftyUserDefaults

func gOverviewReducer(action:Action, state:OverviewState?) -> OverviewState {
    var state = state ?? OverviewState()
        
    switch action {
    case let action as MBalanceFetchedAction:
        if var viewmodel = state.info.value {
            if let balance = action.balance.arrayValue.first?.string {
                viewmodel.balance = balance
            } else {
                viewmodel.balance = "0.0000 \(NetworkConfiguration.EOSIODefaultSymbol)"
            }
            viewmodel.allAssets = calculateTotalAsset(viewmodel)
            viewmodel.CNY = calculateRMBPrice(viewmodel)

            state.info.accept(viewmodel)
        } else {
            var viewmodel = NewHomeViewModel()
            viewmodel.bottomIsHidden = false
            if let balance = action.balance.arrayValue.first?.string {
                viewmodel.balance = balance
            } else {
                viewmodel.balance = "0.0000 \(NetworkConfiguration.EOSIODefaultSymbol)"
            }
            state.info.accept(viewmodel)
        }
    case let action as MAccountFetchedAction:
        if var viewmodel = state.info.value {
            viewmodel = convertViewModelWithAccount(action.info, viewmodel: viewmodel, currencyID: CurrencyManager.shared.getCurrentCurrencyID())
            viewmodel.CNY = calculateRMBPrice(viewmodel)

            state.info.accept(viewmodel)
        } else {
            var viewmodel = NewHomeViewModel()
            viewmodel.bottomIsHidden = false
            viewmodel = convertViewModelWithAccount(action.info, viewmodel: viewmodel, currencyID: CurrencyManager.shared.getCurrentCurrencyID())
            state.info.accept(viewmodel)
        }
    case _ as RMBPriceFetchedAction:
        var viewmodel = state.info.value
        if let eos = CurrencyManager.shared.getCNYPrice() {
            state.cnyPrice = eos
        }
        if let usd = CurrencyManager.shared.getUSDPrice() {
            state.otherPrice = usd
        }
        if viewmodel != nil {
            viewmodel!.CNY = calculateRMBPrice(viewmodel!)
        }
        state.info.accept(viewmodel)
    case let action as TokensFetchedAction:
        let model = convertViewModelWithAccount(tokensJson: action.data)
        state.tokens.accept(model)
        if var viewmodel = state.info.value {
            viewmodel = setTokenWith(tokens: action.data, viewmodel: viewmodel)
            state.info.accept(viewmodel)
        } else {
            var viewmodel = NewHomeViewModel()
            viewmodel.bottomIsHidden = false
            viewmodel = setTokenWith(tokens: action.data, viewmodel: viewmodel)
            state.info.accept(viewmodel)
        }
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
        model.iconUrl = token.logoUrl
        model.balance = token.balance
        model.contract = token.code
        modelArray.append(model)
        let precision = getPrecision(model.balance)
        CurrencyManager.shared.savePrecision(model.name, precision: precision)
    }
    return modelArray
}
