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

func TransferReducer(action:Action, state:TransferState?) -> TransferState {
    let state = state ?? TransferState()
    
    
    switch action {
    case let action as BalanceFetchedAction:
        if action.balance != nil {
            if let balance = action.balance?.arrayValue.first?.string {
                state.balance.accept(balance)
            }
        } else {
            state.balance.accept("")
        }
    case let action as AccountFetchedFromLocalAction:
        if let name = action.model?.account_name {
            if let balance = Defaults[name + NetworkConfiguration.BALANCE_DEFAULT_SYMBOL] as? String {
                state.balanceLocal.accept(balance)
                
            }
        }
        else {
            state.balanceLocal.accept("")
        }
    case let action as moneyAction:
        if let balanceDouble = action.balance.components(separatedBy: " ")[0].toDouble(), let moneyDouble = action.money.toDouble() {
            var valid = false
            var tips = R.string.localizable.big_money.key.localized()
            if balanceDouble >= moneyDouble {
                valid = true
                tips = ""
            }
            
            if moneyDouble < (1 / pow(10, AppConfiguration.EOS_PRECISION)).doubleValue {
                valid = false
                tips = R.string.localizable.small_money.key.localized()
            }
            
            
            
            
            state.moneyValid.accept((valid,tips))
        }
    case let action as toNameAction:
        state.toNameValid.accept(action.isValid)
        
    default:
        break
    }
    
    return state
}



