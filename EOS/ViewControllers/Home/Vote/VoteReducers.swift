//
//  VoteReducers.swift
//  EOS
//
//  Created peng zhu on 2018/8/8.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

func VoteReducer(action:Action, state:VoteState?) -> VoteState {
    return VoteState(isLoading: loadingReducer(state?.isLoading, action: action), page: pageReducer(state?.page, action: action), errorMessage: errorMessageReducer(state?.errorMessage, action: action), property: VotePropertyReducer(state?.property, action: action), callback:state?.callback ?? VoteCallbackState())
}

func VotePropertyReducer(_ state: VotePropertyState?, action: Action) -> VotePropertyState {
    var state = state ?? VotePropertyState()
    
    switch action {
    default:
        break
    }
    
    return state
}



