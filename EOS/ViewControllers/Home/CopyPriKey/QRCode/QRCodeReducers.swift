//
//  QRCodeReducers.swift
//  EOS
//
//  Created peng zhu on 2018/8/1.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

func gQRCodeReducer(action: Action, state: QRCodeState?) -> QRCodeState {
    return QRCodeState(isLoading: loadingReducer(state?.isLoading, action: action),
                       page: pageReducer(state?.page, action: action),
                       errorMessage: errorMessageReducer(state?.errorMessage, action: action),
                       property: gQRCodePropertyReducer(state?.property, action: action))
}

func gQRCodePropertyReducer(_ state: QRCodePropertyState?, action: Action) -> QRCodePropertyState {
    let state = state ?? QRCodePropertyState()

    switch action {
    default:
        break
    }

    return state
}
