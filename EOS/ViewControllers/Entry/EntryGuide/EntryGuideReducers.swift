//
//  EntryGuideReducers.swift
//  EOS
//
//  Created peng zhu on 2018/7/12.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

func EntryGuideReducer(action: Action, state: EntryGuideState?) -> EntryGuideState {
    return EntryGuideState(isLoading: loadingReducer(state?.isLoading, action: action), page: pageReducer(state?.page, action: action), errorMessage: errorMessageReducer(state?.errorMessage, action: action), property: EntryGuidePropertyReducer(state?.property, action: action))
}

func EntryGuidePropertyReducer(_ state: EntryGuidePropertyState?, action: Action) -> EntryGuidePropertyState {
    let state = state ?? EntryGuidePropertyState()

    switch action {
    default:
        break
    }

    return state
}
