//
//  PriKeyReducers.swift
//  EOS
//
//  Created peng zhu on 2018/8/1.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

func PriKeyReducer(action:Action, state:PriKeyState?) -> PriKeyState {
    return PriKeyState(isLoading: loadingReducer(state?.isLoading, action: action), page: pageReducer(state?.page, action: action), errorMessage: errorMessageReducer(state?.errorMessage, action: action), property: PriKeyPropertyReducer(state?.property, action: action))
}

func PriKeyPropertyReducer(_ state: PriKeyPropertyState?, action: Action) -> PriKeyPropertyState {
    let state = state ?? PriKeyPropertyState()
    
    switch action {
    default:
        break
    }
    
    return state
}



