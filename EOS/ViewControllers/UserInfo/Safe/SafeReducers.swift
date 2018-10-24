//
//  SafeReducers.swift
//  EOS
//
//  Created DKM on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

func SafeReducer(action: Action, state: SafeState?) -> SafeState {
    return SafeState(isLoading: loadingReducer(state?.isLoading, action: action), page: pageReducer(state?.page, action: action), errorMessage: errorMessageReducer(state?.errorMessage, action: action), property: SafePropertyReducer(state?.property, action: action))
}

func SafePropertyReducer(_ state: SafePropertyState?, action: Action) -> SafePropertyState {
    let state = state ?? SafePropertyState()

    switch action {
    default:
        break
    }

    return state
}
