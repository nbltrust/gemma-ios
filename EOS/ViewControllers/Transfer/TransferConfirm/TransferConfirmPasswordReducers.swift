//
//  TransferConfirmPasswordReducers.swift
//  EOS
//
//  Created 朱宋宇 on 2018/7/12.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

func TransferConfirmPasswordReducer(action:Action, state:TransferConfirmPasswordState?) -> TransferConfirmPasswordState {
    return TransferConfirmPasswordState(isLoading: loadingReducer(state?.isLoading, action: action), page: pageReducer(state?.page, action: action), errorMessage: errorMessageReducer(state?.errorMessage, action: action), property: TransferConfirmPasswordPropertyReducer(state?.property, action: action))
}

func TransferConfirmPasswordPropertyReducer(_ state: TransferConfirmPasswordPropertyState?, action: Action) -> TransferConfirmPasswordPropertyState {
    var state = state ?? TransferConfirmPasswordPropertyState()
    
    switch action {
    default:
        break
    }
    
    return state
}



