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
    let state = state ?? OverviewState()
        
    switch action {
    case let action as MBalanceFetchedAction:
        if var viewmodel = state.info.value {
            if let balance = action.balance.arrayValue.first?.string {
                viewmodel.balance = balance
            } else {
                viewmodel.balance = "- \(NetworkConfiguration.EOSIODefaultSymbol)"
            }
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
    default:
        break
    }
        
    return state
}


