//
//  PaymentsReducers.swift
//  EOS
//
//  Created 朱宋宇 on 2018/7/10.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

func gPaymentsReducer(action: Action, state: PaymentsState?) -> PaymentsState {
    return PaymentsState(isLoading: loadingReducer(state?.isLoading, action: action),
                         page: pageReducer(state?.page, action: action),
                         errorMessage: errorMessageReducer(state?.errorMessage, action: action),
                         property: gPaymentsPropertyReducer(state?.property, action: action))
}

func gPaymentsPropertyReducer(_ state: PaymentsPropertyState?, action: Action) -> PaymentsPropertyState {
    var state = state ?? PaymentsPropertyState()

    switch action {
    case let action as FetchPaymentsRecordsListAction:
        state.payments = action.data
        let mData: [String: [PaymentsRecordsViewModel]] = convertTransferViewModel(data: action.data, dict: state.data)
        state.data = mData
    case let action as GetLastPosAction:
        state.lastPos = action.lastPos
    default:
        break
    }

    return state
}

