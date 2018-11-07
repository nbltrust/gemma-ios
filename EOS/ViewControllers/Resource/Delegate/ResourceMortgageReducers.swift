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

func gResourceMortgageReducer(action: Action, state: ResourceMortgageState?) -> ResourceMortgageState {
    return ResourceMortgageState(isLoading: loadingReducer(state?.isLoading, action: action),
                                 page: pageReducer(state?.page, action: action),
                                 errorMessage: errorMessageReducer(state?.errorMessage, action: action),
                                 property: gResourceMortgagePropertyReducer(state?.property, action: action))
}

func gResourceMortgagePropertyReducer(_ state: ResourceMortgagePropertyState?, action: Action) -> ResourceMortgagePropertyState {
    let state = state ?? ResourceMortgagePropertyState()

    switch action {
    case let action as CpuMoneyAction:
        if let balanceDouble = action.balance.components(separatedBy: " ")[0].toDouble(), let cpuMoneyDouble = action.cpuMoney.toDouble(), let netMoneyDouble = action.netMoney.toDouble() {
            var valid = false
            var tips = R.string.localizable.big_money.key.localized()
            if balanceDouble >= cpuMoneyDouble + netMoneyDouble {
                valid = true
                tips = ""
            }

            if cpuMoneyDouble < (1 / pow(10, AppConfiguration.EOSPrecision)).doubleValue, action.cpuMoney != "", netMoneyDouble == 0 {
                valid = false
                if action.netMoney != "" {
                    tips = R.string.localizable.delegate_not_all0.key.localized()
                } else {
                    tips = R.string.localizable.small_money.key.localized()
                }
            }

            state.cpuMoneyValid.accept((valid, tips, action.cpuMoney))
        }
    case let action as NetMoneyAction:
        if let balanceDouble = action.balance.components(separatedBy: " ")[0].toDouble(), let cpuMoneyDouble = action.cpuMoney.toDouble(), let netMoneyDouble = action.netMoney.toDouble() {
            var valid = false
            var tips = R.string.localizable.big_money.key.localized()
            if balanceDouble >= cpuMoneyDouble + netMoneyDouble {
                valid = true
                tips = ""
            }

            if netMoneyDouble < (1 / pow(10, AppConfiguration.EOSPrecision)).doubleValue, action.netMoney != "", cpuMoneyDouble == 0 {
                valid = false
                if action.cpuMoney != "" {
                    tips = R.string.localizable.delegate_not_all0.key.localized()
                } else {
                    tips = R.string.localizable.small_money.key.localized()
                }
            }

            state.netMoneyValid.accept((valid, tips, action.netMoney))
        }
    case let action as CpuReliveMoneyAction:
        if let balanceDouble = action.balance.components(separatedBy: " ")[0].toDouble(), let cpuMoneyDouble = action.cpuMoney.toDouble(), let netMoneyDouble = action.netMoney.toDouble() {
            var valid = false
            var tips = R.string.localizable.big_money.key.localized()
            if balanceDouble >= cpuMoneyDouble {
                valid = true
                tips = ""
            }

            if cpuMoneyDouble < (1 / pow(10, AppConfiguration.EOSPrecision)).doubleValue, action.cpuMoney != "", netMoneyDouble == 0 {
                valid = false
                if action.netMoney != "" {
                    tips = R.string.localizable.delegate_not_all0.key.localized()
                } else {
                    tips = R.string.localizable.small_money.key.localized()
                }
            }

            state.cpuReliveMoneyValid.accept((valid, tips, action.cpuMoney))
        }
    case let action as NetReliveMoneyAction:
        if let balanceDouble = action.balance.components(separatedBy: " ")[0].toDouble(), let cpuMoneyDouble = action.cpuMoney.toDouble(), let netMoneyDouble = action.netMoney.toDouble() {
            var valid = false
            var tips = R.string.localizable.big_money.key.localized()
            if balanceDouble >= netMoneyDouble {
                valid = true
                tips = ""
            }

            if netMoneyDouble < (1 / pow(10, AppConfiguration.EOSPrecision)).doubleValue, action.netMoney != "", cpuMoneyDouble == 0 {
                valid = false
                if action.cpuMoney != "" {
                    tips = R.string.localizable.delegate_not_all0.key.localized()
                } else {
                    tips = R.string.localizable.small_money.key.localized()
                }
            }

            state.netReliveMoneyValid.accept((valid, tips, action.netMoney))
        }
    case let action as MAccountFetchedAction:
        var viewmodel = state.info.value
        viewmodel = convertResourceViewModelWithAccount(action.info, viewmodel: viewmodel)
            state.info.accept(viewmodel)

    default:
        break
    }

    return state
}


