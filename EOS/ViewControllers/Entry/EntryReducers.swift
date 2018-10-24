//
//  EntryReducers.swift
//  EOS
//
//  Created koofrank on 2018/7/4.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

func gEntryReducer(action: Action, state: EntryState?) -> EntryState {
    return EntryState(isLoading: loadingReducer(state?.isLoading, action: action),
                      page: pageReducer(state?.page, action: action),
                      errorMessage: errorMessageReducer(state?.errorMessage, action: action),
                      property: gEntryPropertyReducer(state?.property, action: action),
                      callback: state?.callback ?? EntryCallbackState())
}

func gEntryPropertyReducer(_ state: EntryPropertyState?, action: Action) -> EntryPropertyState {
    let state = state ?? EntryPropertyState()

    switch action {
    case let action as NameAction:
        state.nameValid.accept(action.isValid)
    case let action as PasswordAction:
        state.passwordValid.accept(action.isValid)
    case let action as ComfirmPasswordAction:
        state.comfirmPasswordValid.accept(action.isValid)
    case let action as AgreeAction:
        state.isAgree.accept(action.isAgree)
    case let action as SetCheckSeedSuccessedAction:
        state.checkSeedSuccessed.accept(action.isCheck)
    default:
        break
    }

    return state
}
