//
//  PaymentsReducers.swift
//  EOS
//
//  Created 朱宋宇 on 2018/7/10.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

func PaymentsReducer(action:Action, state:PaymentsState?) -> PaymentsState {
    return PaymentsState(isLoading: loadingReducer(state?.isLoading, action: action), page: pageReducer(state?.page, action: action), errorMessage: errorMessageReducer(state?.errorMessage, action: action), property: PaymentsPropertyReducer(state?.property, action: action))
}

func PaymentsPropertyReducer(_ state: PaymentsPropertyState?, action: Action) -> PaymentsPropertyState {
    var state = state ?? PaymentsPropertyState()
    
    switch action {
    case let action as FetchPaymentsRecordsListAction:
        let mData : [PaymentsRecordsViewModel] = convertTransferViewModel(data: action.data)
        state.data = mData
    default:
        break
    }
    
    return state
}

func convertTransferViewModel(data:[Any]) -> [PaymentsRecordsViewModel] {
    return [PaymentsRecordsViewModel.init(name: "data[0]", date: "data[0]", confirme: "", money: "")]
}

