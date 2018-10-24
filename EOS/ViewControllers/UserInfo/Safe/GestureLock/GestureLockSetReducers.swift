//
//  GestureLockSetReducers.swift
//  EOS
//
//  Created peng zhu on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

func gGestureLockSetReducer(action: Action, state: GestureLockSetState?) -> GestureLockSetState {
    return GestureLockSetState(isLoading: loadingReducer(state?.isLoading, action: action),
                               page: pageReducer(state?.page, action: action),
                               errorMessage: errorMessageReducer(state?.errorMessage, action: action),
                               property: gGestureLockSetPropertyReducer(state?.property, action: action),
                               callback: state?.callback ?? GestureLockSetCallbackState())
}

func gGestureLockSetPropertyReducer(_ state: GestureLockSetPropertyState?, action: Action) -> GestureLockSetPropertyState {
    let state = state ?? GestureLockSetPropertyState()

    switch action {
    case let action as SetPasswordAction:
        state.password.accept(action.password)
    case let action as SetValidedPasswordAction:
        state.validedPassword.accept(action.valided)
    case let action as SetPromotDataAction:
        state.promotData.accept(action.data)
    case let action as SetReDrawFailedNumAction:
        state.reDrawFailedNum.accept(action.num)
    default:
        break
    }

    return state
}
