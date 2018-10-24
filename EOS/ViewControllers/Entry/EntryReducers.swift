//
//  EntryReducers.swift
//  EOS
//
//  Created koofrank on 2018/7/4.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

func EntryReducer(action: Action, state: EntryState?) -> EntryState {
    return EntryState(isLoading: loadingReducer(state?.isLoading, action: action), page: pageReducer(state?.page, action: action), errorMessage: errorMessageReducer(state?.errorMessage, action: action), property: EntryPropertyReducer(state?.property, action: action), callback: state?.callback ?? EntryCallbackState())
}

func EntryPropertyReducer(_ state: EntryPropertyState?, action: Action) -> EntryPropertyState {
    let state = state ?? EntryPropertyState()

    switch action {
    case let action as nameAction:
        state.nameValid.accept(action.isValid)
    case let action as passwordAction:
        state.passwordValid.accept(action.isValid)
    case let action as comfirmPasswordAction:
        state.comfirmPasswordValid.accept(action.isValid)
    case let action as agreeAction:
        state.isAgree.accept(action.isAgree)
    case let action as SetCheckSeedSuccessedAction:
        state.checkSeedSuccessed.accept(action.isCheck)
    default:
        break
    }

    return state
}
