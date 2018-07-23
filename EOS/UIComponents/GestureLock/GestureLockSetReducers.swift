//
//  GestureLockSetReducers.swift
//  EOS
//
//  Created peng zhu on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

func GestureLockSetReducer(action:Action, state:GestureLockSetState?) -> GestureLockSetState {
    return GestureLockSetState(isLoading: loadingReducer(state?.isLoading, action: action), page: pageReducer(state?.page, action: action), errorMessage: errorMessageReducer(state?.errorMessage, action: action), property: GestureLockSetPropertyReducer(state?.property, action: action))
}

func GestureLockSetPropertyReducer(_ state: GestureLockSetPropertyState?, action: Action) -> GestureLockSetPropertyState {
    var state = state ?? GestureLockSetPropertyState()
    
    switch action {
    default:
        break
    }
    
    return state
}



