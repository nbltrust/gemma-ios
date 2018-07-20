//
//  WalletReducers.swift
//  EOS
//
//  Created zhusongyu on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

func WalletReducer(action:Action, state:WalletState?) -> WalletState {
    return WalletState(isLoading: loadingReducer(state?.isLoading, action: action), page: pageReducer(state?.page, action: action), errorMessage: errorMessageReducer(state?.errorMessage, action: action), property: WalletPropertyReducer(state?.property, action: action))
}

func WalletPropertyReducer(_ state: WalletPropertyState?, action: Action) -> WalletPropertyState {
    var state = state ?? WalletPropertyState()
    
    switch action {
    default:
        break
    }
    
    return state
}



