//
//  NormalReducers.swift
//  EOS
//
//  Created DKM on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

func NormalReducer(action:Action, state:NormalState?) -> NormalState {
    return NormalState(isLoading: loadingReducer(state?.isLoading, action: action), page: pageReducer(state?.page, action: action), errorMessage: errorMessageReducer(state?.errorMessage, action: action), property: NormalPropertyReducer(state?.property, action: action))
}

func NormalPropertyReducer(_ state: NormalPropertyState?, action: Action) -> NormalPropertyState {
    let state = state ?? NormalPropertyState()
    
    switch action {
    default:
        break
    }
    
    return state
}



