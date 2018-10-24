//
//  FingerPrinterConfirmReducers.swift
//  EOS
//
//  Created peng zhu on 2018/8/3.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

func FingerPrinterConfirmReducer(action:Action, state:FingerPrinterConfirmState?) -> FingerPrinterConfirmState {
    return FingerPrinterConfirmState(isLoading: loadingReducer(state?.isLoading, action: action), page: pageReducer(state?.page, action: action), errorMessage: errorMessageReducer(state?.errorMessage, action: action), property: FingerPrinterConfirmPropertyReducer(state?.property, action: action), callback: state?.callback ?? FingerPrinterConfirmCallbackState())
}

func FingerPrinterConfirmPropertyReducer(_ state: FingerPrinterConfirmPropertyState?, action: Action) -> FingerPrinterConfirmPropertyState {
    let state = state ?? FingerPrinterConfirmPropertyState()
    
    switch action {
    default:
        break
    }
    
    return state
}



