//
//  PaymentsDetailReducers.swift
//  EOS
//
//  Created 朱宋宇 on 2018/7/10.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

func gPaymentsDetailReducer(action: Action, state: PaymentsDetailState?) -> PaymentsDetailState {
    return PaymentsDetailState(isLoading: loadingReducer(state?.isLoading, action: action),
                               page: pageReducer(state?.page, action: action),
                               errorMessage: errorMessageReducer(state?.errorMessage, action: action),
                               property: gPaymentsDetailPropertyReducer(state?.property, action: action))
}

func gPaymentsDetailPropertyReducer(_ state: PaymentsDetailPropertyState?, action: Action) -> PaymentsDetailPropertyState {
    var state = state ?? PaymentsDetailPropertyState()

    switch action {
    default:
        break
    }

    return state
}
