//
//  CreatationCompleteReducers.swift
//  EOS
//
//  Created peng zhu on 2018/7/12.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

func gCreatationCompleteReducer(action: Action, state: CreatationCompleteState?) -> CreatationCompleteState {
    return CreatationCompleteState(isLoading: loadingReducer(state?.isLoading, action: action),
                                   page: pageReducer(state?.page, action: action),
                                   errorMessage: errorMessageReducer(state?.errorMessage, action: action),
                                   property: gCreatationCompletePropertyReducer(state?.property, action: action))
}

func gCreatationCompletePropertyReducer(_ state: CreatationCompletePropertyState?, action: Action) -> CreatationCompletePropertyState {
    let state = state ?? CreatationCompletePropertyState()

    switch action {
    default:
        break
    }

    return state
}
