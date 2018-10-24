//
//  GestureLockComfirmReducers.swift
//  EOS
//
//  Created peng zhu on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

func GestureLockComfirmReducer(action: Action, state: GestureLockComfirmState?) -> GestureLockComfirmState {
    return GestureLockComfirmState(isLoading: loadingReducer(state?.isLoading, action: action), page: pageReducer(state?.page, action: action), errorMessage: errorMessageReducer(state?.errorMessage, action: action), property: GestureLockComfirmPropertyReducer(state?.property, action: action), callback: state?.callback ?? GestureLockConfirmCallbackState())
}

func GestureLockComfirmPropertyReducer(_ state: GestureLockComfirmPropertyState?, action: Action) -> GestureLockComfirmPropertyState {
    let state = state ?? GestureLockComfirmPropertyState()

    switch action {
    case let action as SetConfirmPromotDataAction:
        state.promotData.accept(action.data)
    case let action as SetReDrawFailedNumAction:
        state.reDrawFailedNum.accept(action.num)
    case let action as SetGestureLockLockedAction:
        state.locked.accept(action.value)
    default:
        break
    }

    return state
}
