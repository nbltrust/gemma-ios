//
//  FaceIDComfirmReducers.swift
//  EOS
//
//  Created peng zhu on 2018/8/3.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

func gFaceIDComfirmReducer(action: Action, state: FaceIDComfirmState?) -> FaceIDComfirmState {
    return FaceIDComfirmState(isLoading: loadingReducer(state?.isLoading, action: action),
                              page: pageReducer(state?.page, action: action),
                              errorMessage: errorMessageReducer(state?.errorMessage, action: action),
                              property: gFaceIDComfirmPropertyReducer(state?.property, action: action),
                              callback: state?.callback ?? FaceIDConfirmCallbackState())
}

func gFaceIDComfirmPropertyReducer(_ state: FaceIDComfirmPropertyState?, action: Action) -> FaceIDComfirmPropertyState {
    let state = state ?? FaceIDComfirmPropertyState()

    switch action {
    default:
        break
    }

    return state
}
