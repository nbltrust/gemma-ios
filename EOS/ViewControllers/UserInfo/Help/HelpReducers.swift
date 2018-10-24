//
//  HelpReducers.swift
//  EOS
//
//  Created DKM on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

func gHelpReducer(action: Action, state: HelpState?) -> HelpState {
    return HelpState(isLoading: loadingReducer(state?.isLoading, action: action),
                     page: pageReducer(state?.page, action: action),
                     errorMessage: errorMessageReducer(state?.errorMessage, action: action),
                     property: gHelpPropertyReducer(state?.property, action: action))
}

func gHelpPropertyReducer(_ state: HelpPropertyState?, action: Action) -> HelpPropertyState {
    let state = state ?? HelpPropertyState()

    switch action {
    default:
        break
    }

    return state
}
