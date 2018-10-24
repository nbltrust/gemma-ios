//
//  ChangeWalletNameReducers.swift
//  EOS
//
//  Created zhusongyu on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

func ChangeWalletNameReducer(action:Action, state:ChangeWalletNameState?) -> ChangeWalletNameState {
    return ChangeWalletNameState(isLoading: loadingReducer(state?.isLoading, action: action), page: pageReducer(state?.page, action: action), errorMessage: errorMessageReducer(state?.errorMessage, action: action), property: ChangeWalletNamePropertyReducer(state?.property, action: action))
}

func ChangeWalletNamePropertyReducer(_ state: ChangeWalletNamePropertyState?, action: Action) -> ChangeWalletNamePropertyState {
    let state = state ?? ChangeWalletNamePropertyState()
    
    switch action {
    default:
        break
    }
    
    return state
}



