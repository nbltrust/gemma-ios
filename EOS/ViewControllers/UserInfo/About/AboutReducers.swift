//
//  AboutReducers.swift
//  EOS
//
//  Created DKM on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

func AboutReducer(action:Action, state:AboutState?) -> AboutState {
    return AboutState(isLoading: loadingReducer(state?.isLoading, action: action), page: pageReducer(state?.page, action: action), errorMessage: errorMessageReducer(state?.errorMessage, action: action), property: AboutPropertyReducer(state?.property, action: action))
}

func AboutPropertyReducer(_ state: AboutPropertyState?, action: Action) -> AboutPropertyState {
    var state = state ?? AboutPropertyState()
    
    switch action {
    default:
        break
    }
    
    return state
}



