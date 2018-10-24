//
//  LeadInReducers.swift
//  EOS
//
//  Created DKM on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

func LeadInReducer(action:Action, state:LeadInState?) -> LeadInState {
    return LeadInState(isLoading: loadingReducer(state?.isLoading, action: action), page: pageReducer(state?.page, action: action), errorMessage: errorMessageReducer(state?.errorMessage, action: action), property: LeadInPropertyReducer(state?.property, action: action), callback: state?.callback ?? LeadInCallbackState())
}

func LeadInPropertyReducer(_ state: LeadInPropertyState?, action: Action) -> LeadInPropertyState {
    let state = state ?? LeadInPropertyState()
    
    switch action {
    default:
        break
    }
    
    return state
}



