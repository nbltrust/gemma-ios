//
//  UserInfoReducers.swift
//  EOS
//
//  Created koofrank on 2018/7/12.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

func UserInfoReducer(action:Action, state:UserInfoState?) -> UserInfoState {
    return UserInfoState(isLoading: loadingReducer(state?.isLoading, action: action), page: pageReducer(state?.page, action: action), errorMessage: errorMessageReducer(state?.errorMessage, action: action), property: UserInfoPropertyReducer(state?.property, action: action))
}

func UserInfoPropertyReducer(_ state: UserInfoPropertyState?, action: Action) -> UserInfoPropertyState {
    let state = state ?? UserInfoPropertyState()
    
    switch action {
    default:
        break
    }
    
    return state
}



