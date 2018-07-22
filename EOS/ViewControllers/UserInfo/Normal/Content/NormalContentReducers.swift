//
//  NormalContentReducers.swift
//  EOS
//
//  Created DKM on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

func NormalContentReducer(action:Action, state:NormalContentState?) -> NormalContentState {
    return NormalContentState(isLoading: loadingReducer(state?.isLoading, action: action), page: pageReducer(state?.page, action: action), errorMessage: errorMessageReducer(state?.errorMessage, action: action), property: NormalContentPropertyReducer(state?.property, action: action))
}

func NormalContentPropertyReducer(_ state: NormalContentPropertyState?, action: Action) -> NormalContentPropertyState {
    var state = state ?? NormalContentPropertyState()
    
    switch action {
    case let action as SetDataAction :
        state.data = action.data
    default:
        break
    }
    
    return state
}



