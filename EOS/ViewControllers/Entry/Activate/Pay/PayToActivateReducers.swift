//
//  PayToActivateReducers.swift
//  EOS
//
//  Created zhusongyu on 2018/9/6.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift

func PayToActivateReducer(action:Action, state:PayToActivateState?) -> PayToActivateState {
    let state = state ?? PayToActivateState()
        
    switch action {
    case let action as BillAction:
        let model = transToModel(action)
        state.billInfo.accept(model)
    default:
        break
    }
        
    return state
}

func transToModel(_ action: BillAction) -> BillModel {
    var model = BillModel()
    model.cpu = action.data.cpu + " \(NetworkConfiguration.EOSIO_DEFAULT_SYMBOL)"
    model.net = action.data.net + " \(NetworkConfiguration.EOSIO_DEFAULT_SYMBOL)"
    model.ram = action.data.ram + " \(NetworkConfiguration.EOSIO_DEFAULT_SYMBOL)"
    model.rmb = action.data.rmbPrice + " RMB"
    return model
}
