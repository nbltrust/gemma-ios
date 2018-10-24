//
//  AccountListReducers.swift
//  EOS
//
//  Created zhusongyu on 2018/7/23.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

func gAccountListReducer(action: Action, state: AccountListState?) -> AccountListState {
    return AccountListState(isLoading: loadingReducer(state?.isLoading, action: action), page: pageReducer(state?.page, action: action), errorMessage: errorMessageReducer(state?.errorMessage, action: action), property: gAccountListPropertyReducer(state?.property, action: action))
}

func gAccountListPropertyReducer(_ state: AccountListPropertyState?, action: Action) -> AccountListPropertyState {
    let state = state ?? AccountListPropertyState()

    switch action {
    default:
        break
    }

    return state
}
