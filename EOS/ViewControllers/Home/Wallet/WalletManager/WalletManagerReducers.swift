//
//  WalletManagerReducers.swift
//  EOS
//
//  Created zhusongyu on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

func WalletManagerReducer(action: Action, state: WalletManagerState?) -> WalletManagerState {
    return WalletManagerState(isLoading: loadingReducer(state?.isLoading, action: action), page: pageReducer(state?.page, action: action), errorMessage: errorMessageReducer(state?.errorMessage, action: action), property: WalletManagerPropertyReducer(state?.property, action: action))
}

func WalletManagerPropertyReducer(_ state: WalletManagerPropertyState?, action: Action) -> WalletManagerPropertyState {
    let state = state ?? WalletManagerPropertyState()

    switch action {
    default:
        break
    }

    return state
}
