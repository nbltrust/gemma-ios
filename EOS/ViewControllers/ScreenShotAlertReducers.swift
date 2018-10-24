//
//  ScreenShotAlertReducers.swift
//  EOS
//
//  Created zhusongyu on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

func gScreenShotAlertReducer(action: Action, state: ScreenShotAlertState?) -> ScreenShotAlertState {
    return ScreenShotAlertState(isLoading: loadingReducer(state?.isLoading, action: action),
                                page: pageReducer(state?.page, action: action),
                                errorMessage: errorMessageReducer(state?.errorMessage, action: action),
                                property: gScreenShotAlertPropertyReducer(state?.property, action: action))
}

func gScreenShotAlertPropertyReducer(_ state: ScreenShotAlertPropertyState?, action: Action) -> ScreenShotAlertPropertyState {
    var state = state ?? ScreenShotAlertPropertyState()

    switch action {
    default:
        break
    }

    return state
}
