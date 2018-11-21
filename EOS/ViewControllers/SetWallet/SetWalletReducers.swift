//
//  SetWalletReducers.swift
//  EOS
//
//  Created DKM on 2018/7/20.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

func gSetWalletReducer(action: Action, state: SetWalletState?) -> SetWalletState {
    return SetWalletState(isLoading: loadingReducer(state?.isLoading, action: action),
                          page: pageReducer(state?.page, action: action),
                          errorMessage: errorMessageReducer(state?.errorMessage, action: action),
                          property: gSetWalletPropertyReducer(state?.property, action: action),
                          callback: state?.callback ?? SetWalletCallbackState())
}

func gSetWalletPropertyReducer(_ state: SetWalletPropertyState?, action: Action) -> SetWalletPropertyState {
    let state = state ?? SetWalletPropertyState()

    switch action {
    case let action as SetWalletNameAction:
        state.setWalletNameValid.accept(action.isValid)
    case let action as SetWalletPasswordAction:
        state.setWalletPasswordValid.accept(action.isValid)
    case let action as SetWalletComfirmPasswordAction:
        state.setWalletComfirmPasswordValid.accept(action.isValid)
    case let action as SetWalletAgreeAction:
        state.setWalletIsAgree.accept(action.isAgree)
    default:
        break
    }

    return state
}
