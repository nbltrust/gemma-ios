//
//  AboutReducers.swift
//  EOS
//
//  Created DKM on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

func gAboutReducer(action: Action, state: AboutState?) -> AboutState {
    return AboutState(isLoading: loadingReducer(state?.isLoading, action: action),
                      page: pageReducer(state?.page, action: action),
                      errorMessage: errorMessageReducer(state?.errorMessage, action: action),
                      property: gAboutPropertyReducer(state?.property, action: action))
}

func gAboutPropertyReducer(_ state: AboutPropertyState?, action: Action) -> AboutPropertyState {
    let state = state ?? AboutPropertyState()

    switch action {
    default:
        break
    }

    return state
}
