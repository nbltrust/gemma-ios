//
//  TransferConfirmReducers.swift
//  EOS
//
//  Created 朱宋宇 on 2018/7/12.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

func TransferConfirmReducer(action:Action, state:TransferConfirmState?) -> TransferConfirmState {
    return TransferConfirmState(isLoading: loadingReducer(state?.isLoading, action: action), page: pageReducer(state?.page, action: action), errorMessage: errorMessageReducer(state?.errorMessage, action: action), property: TransferConfirmPropertyReducer(state?.property, action: action))
}

func TransferConfirmPropertyReducer(_ state: TransferConfirmPropertyState?, action: Action) -> TransferConfirmPropertyState {
    var state = state ?? TransferConfirmPropertyState()
    
    switch action {
    default:
        break
    }
    
    return state
}



