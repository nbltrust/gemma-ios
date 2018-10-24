//
//  CopyPriKeyReducers.swift
//  EOS
//
//  Created peng zhu on 2018/8/1.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

func gCopyPriKeyReducer(action: Action, state: CopyPriKeyState?) -> CopyPriKeyState {
    return CopyPriKeyState(isLoading: loadingReducer(state?.isLoading, action: action),
                           page: pageReducer(state?.page, action: action),
                           errorMessage: errorMessageReducer(state?.errorMessage, action: action),
                           property: gCopyPriKeyPropertyReducer(state?.property, action: action))
}

func gCopyPriKeyPropertyReducer(_ state: CopyPriKeyPropertyState?, action: Action) -> CopyPriKeyPropertyState {
    let state = state ?? CopyPriKeyPropertyState()

    switch action {
    default:
        break
    }

    return state
}
