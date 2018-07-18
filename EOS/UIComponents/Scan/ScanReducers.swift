//
//  ScanReducers.swift
//  EOS
//
//  Created peng zhu on 2018/7/16.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

func ScanReducer(action:Action, state:ScanState?) -> ScanState {
    return ScanState(isLoading: loadingReducer(state?.isLoading, action: action), page: pageReducer(state?.page, action: action), errorMessage: errorMessageReducer(state?.errorMessage, action: action), property: ScanPropertyReducer(state?.property, action: action))
}

func ScanPropertyReducer(_ state: ScanPropertyState?, action: Action) -> ScanPropertyState {
    let state = state ?? ScanPropertyState()
    
    switch action {
    case let action as ScanResultAction:
        state.scanResult.accept(action.scanResult)
    default:
        break
    }
    
    return state
}



