//
//  PayToActivateReducers.swift
//  EOS
//
//  Created zhusongyu on 2018/9/6.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift

func PayToActivateReducer(action: Action, state: PayToActivateState?) -> PayToActivateState {
    var state = state ?? PayToActivateState()

    switch action {
    case let action as BillAction:
        let model = transToModel(action)
        state.billInfo.accept(model)
    case let action as OrderIdAction:
        state.orderId = action.orderId
    case let action as NumsAction:
        state.nums = action.nums + 1
    default:
        break
    }

    return state
}

func transToModel(_ action: BillAction) -> BillModel {
    var model = BillModel()
    model.cpu = action.data.cpu + " \(NetworkConfiguration.EOSIODefaultSymbol)"
    model.net = action.data.net + " \(NetworkConfiguration.EOSIODefaultSymbol)"
    model.ram = action.data.ram + " \(NetworkConfiguration.EOSIODefaultSymbol)"
    model.rmb = action.data.rmbPrice + " RMB"
    return model
}
