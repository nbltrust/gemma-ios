//
//  LeadInKeyReducers.swift
//  EOS
//
//  Created DKM on 2018/7/31.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

func gLeadInKeyReducer(action: Action, state: LeadInKeyState?) -> LeadInKeyState {
    return LeadInKeyState(isLoading: loadingReducer(state?.isLoading, action: action),
                          page: pageReducer(state?.page, action: action),
                          errorMessage: errorMessageReducer(state?.errorMessage, action: action),
                          property: gLeadInKeyPropertyReducer(state?.property, action: action))
}

func gLeadInKeyPropertyReducer(_ state: LeadInKeyPropertyState?, action: Action) -> LeadInKeyPropertyState {
    let state = state ?? LeadInKeyPropertyState()

    switch action {
    default:
        break
    }

    return state
}
