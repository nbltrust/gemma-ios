//
//  HomeReducers.swift
//  EOS
//
//  Created koofrank on 2018/7/4.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

func HomeReducer(action:Action, state:HomeState?) -> HomeState {
    return HomeState(isLoading: loadingReducer(state?.isLoading, action: action), page: pageReducer(state?.page, action: action), errorMessage: errorMessageReducer(state?.errorMessage, action: action), property: HomePropertyReducer(state?.property, action: action))
}

func HomePropertyReducer(_ state: HomePropertyState?, action: Action) -> HomePropertyState {
    var state = state ?? HomePropertyState()
    
    switch action {
    default:
        break
    }
    
    return state
}



