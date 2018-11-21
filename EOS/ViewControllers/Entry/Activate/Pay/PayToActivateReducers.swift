//
//  PayToActivateReducers.swift
//  EOS
//
//  Created zhusongyu on 2018/9/6.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift

func gPayToActivateReducer(action: Action, state: PayToActivateState?) -> PayToActivateState {
    var state = state ?? PayToActivateState()

    switch action {
    case let action as BillAction:
        if let model = transToModel(action) {
            state.billInfo.accept(model)
        }
    case let action as OrderAction:
        state.orderId = action.order.id
        let rmb = state.billInfo.value.rmb.components(separatedBy: " ")[0]
        if rmb != action.order.rmbPrice, let model = transToModel(action) {
            state.orderInfo.accept((model, true))
            state.billInfo.accept(model)
        } else {
            state.orderInfo.accept((nil, false))
        }
    case let action as NumsAction:
        state.nums = action.nums + 1
    default:
        break
    }

    return state
}

func transToModel(_ action: Any) -> BillModel? {
    if let action = action as? BillAction {
        var model = BillModel()
        model.cpu = action.data.cpu + " \(NetworkConfiguration.EOSIODefaultSymbol)"
        model.net = action.data.net + " \(NetworkConfiguration.EOSIODefaultSymbol)"
        model.ram = action.data.ram + " \(NetworkConfiguration.EOSIODefaultSymbol)"
        model.rmb = action.data.rmbPrice + " RMB"
        return model
    }
    if let action = action as? OrderAction {
        var model = BillModel()
        model.cpu = action.order.cpu + " \(NetworkConfiguration.EOSIODefaultSymbol)"
        model.net = action.order.net + " \(NetworkConfiguration.EOSIODefaultSymbol)"
        model.ram = action.order.ram + " \(NetworkConfiguration.EOSIODefaultSymbol)"
        model.rmb = action.order.rmbPrice + " RMB"
        return model
    }
    return nil
}
