//
//  TransferReducers.swift
//  EOS
//
//  Created DKM on 2018/7/11.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift
import SwiftyUserDefaults

func gTransferReducer(action: Action, state: TransferState?) -> TransferState {
    let state = state ?? TransferState()

    switch action {
    case let action as BalanceFetchedAction:
        if action.currencyID != nil {
            if let json = CurrencyManager.shared.getBalanceJsonWith(action.currencyID) {
                if let balance = json.arrayValue.first?.string {
                    state.balance.accept(balance)
                } else {
                    state.balance.accept("")
                }
            }
        }
    case let action as MoneyAction:
        if let balanceDouble = action.balance.components(separatedBy: " ")[0].toDouble(), let moneyDouble = action.money.toDouble() {
            var valid = false
            var tips = R.string.localizable.big_money.key.localized()
            if balanceDouble >= moneyDouble {
                valid = true
                tips = ""
            }

            if moneyDouble < (1 / pow(10, AppConfiguration.EOSPrecision)).doubleValue {
                valid = false
                tips = R.string.localizable.small_money.key.localized()
            }

            state.moneyValid.accept((valid, tips))
        }
    case let action as ToNameAction:
        state.toNameValid.accept(action.isValid)

    default:
        break
    }

    return state
}
