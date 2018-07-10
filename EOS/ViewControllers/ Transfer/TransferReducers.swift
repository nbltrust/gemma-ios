//
//  TransferReducers.swift
//  EOS
//
//  Created 朱宋宇 on 2018/7/10.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

func TransferReducer(action:Action, state:TransferState?) -> TransferState {
    return TransferState(isLoading: loadingReducer(state?.isLoading, action: action), page: pageReducer(state?.page, action: action), errorMessage: errorMessageReducer(state?.errorMessage, action: action), property: TransferPropertyReducer(state?.property, action: action))
}

func TransferPropertyReducer(_ state: TransferPropertyState?, action: Action) -> TransferPropertyState {
    var state = state ?? TransferPropertyState()
    
    switch action {
    default:
        break
    }
    
    return state
}



