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
        if let balanceDouble = action.balance.components(separatedBy: " ")[0].toDecimal(), let cpuMoneyDouble = action.cpuMoney.toDecimal(), let netMoneyDouble = action.netMoney.toDecimal() {
            var valid = false
            var tips = R.string.localizable.big_money.key.localized()
            if balanceDouble >= cpuMoneyDouble + netMoneyDouble {
                valid = true
                tips = ""
            }

            if cpuMoneyDouble < (1 / pow(10, AppConfiguration.EOSPrecision)), action.cpuMoney != "", netMoneyDouble == 0 {
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
        if let balanceDouble = action.balance.components(separatedBy: " ")[0].toDecimal(), let cpuMoneyDouble = action.cpuMoney.toDecimal(), let netMoneyDouble = action.netMoney.toDecimal() {
            var valid = false
            var tips = R.string.localizable.big_money.key.localized()
            if balanceDouble >= cpuMoneyDouble + netMoneyDouble {
                valid = true
                tips = ""
            }

            if netMoneyDouble < (1 / pow(10, AppConfiguration.EOSPrecision)), action.netMoney != "", cpuMoneyDouble == 0 {
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
        if let balanceDouble = action.balance.components(separatedBy: " ")[0].toDecimal(), let cpuMoneyDouble = action.cpuMoney.toDecimal(), let netMoneyDouble = action.netMoney.toDecimal() {
            var valid = false
            var tips = R.string.localizable.big_money.key.localized()
            if balanceDouble >= cpuMoneyDouble {
                valid = true
                tips = ""
            }

            if cpuMoneyDouble < (1 / pow(10, AppConfiguration.EOSPrecision)), action.cpuMoney != "", netMoneyDouble == 0 {
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
        if let balanceDouble = action.balance.components(separatedBy: " ")[0].toDecimal(), let cpuMoneyDouble = action.cpuMoney.toDecimal(), let netMoneyDouble = action.netMoney.toDecimal() {
            var valid = false
            var tips = R.string.localizable.big_money.key.localized()
            if balanceDouble >= netMoneyDouble {
                valid = true
                tips = ""
            }

            if netMoneyDouble < (1 / pow(10, AppConfiguration.EOSPrecision)), action.netMoney != "", cpuMoneyDouble == 0 {
                valid = false
                if action.cpuMoney != "" {
                    tips = R.string.localizable.delegate_not_all0.key.localized()
                } else {
                    tips = R.string.localizable.small_money.key.localized()
                }
            }

            state.netReliveMoneyValid.accept((valid, tips, action.netMoney))
        }
    case let action as FetchDataAction:
        var model = initPageViewModel()
        model.operationLeft[0].introduce = action.balance + " \(R.string.localizable.usable.key.localized())"
        model.operationLeft[1].introduce = action.balance + " \(R.string.localizable.usable.key.localized())"
        model.operationRight[0].introduce = action.cpuBalance + " \(R.string.localizable.usable.key.localized())"
        model.operationRight[1].introduce = action.netBalance + " \(R.string.localizable.usable.key.localized())"
        state.info.accept(model)
    default:
        break
    }

    return state
}

func initPageViewModel() -> PageViewModel {
    var model = PageViewModel()
    model.leftText = R.string.localizable.mortgage.key.localized()
    model.rightText = R.string.localizable.redeem.key.localized()
     
    var opModelLeft1 = OperationViewModel()
    opModelLeft1.isSecureTextEntry = false
    opModelLeft1.isShowPromptWhenEditing = true
    opModelLeft1.placeholder = R.string.localizable.mortgage_placeholder.key.localized()
    opModelLeft1.showLine = true
    opModelLeft1.title = R.string.localizable.mortgage_cpu.key.localized()

    var opModelLeft2 = OperationViewModel()
    opModelLeft2.isSecureTextEntry = false
    opModelLeft2.isShowPromptWhenEditing = true
    opModelLeft2.placeholder = R.string.localizable.mortgage_placeholder.key.localized()
    opModelLeft2.showLine = true
    opModelLeft2.title = R.string.localizable.mortgage_net.key.localized()

    model.operationLeft = [opModelLeft1,opModelLeft2]

    var opModelRight1 = OperationViewModel()
    opModelRight1.isSecureTextEntry = false
    opModelRight1.isShowPromptWhenEditing = true
    opModelRight1.placeholder = R.string.localizable.mortgage_cancel_placeholder.key.localized()
    opModelRight1.showLine = true
    opModelRight1.title = R.string.localizable.cpu.key.localized()

    var opModelRight2 = OperationViewModel()
    opModelRight2.isSecureTextEntry = false
    opModelRight2.isShowPromptWhenEditing = true
    opModelRight2.placeholder = R.string.localizable.mortgage_cancel_placeholder.key.localized()
    opModelRight2.showLine = true
    opModelRight2.title = R.string.localizable.net.key.localized()
    model.operationRight = [opModelRight1,opModelRight2]

    return model
}
