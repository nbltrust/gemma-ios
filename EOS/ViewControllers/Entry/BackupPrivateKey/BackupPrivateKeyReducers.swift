//
//  BackupPrivateKeyReducers.swift
//  EOS
//
//  Created zhusongyu on 2018/8/1.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

func BackupPrivateKeyReducer(action:Action, state:BackupPrivateKeyState?) -> BackupPrivateKeyState {
    return BackupPrivateKeyState(isLoading: loadingReducer(state?.isLoading, action: action), page: pageReducer(state?.page, action: action), errorMessage: errorMessageReducer(state?.errorMessage, action: action), property: BackupPrivateKeyPropertyReducer(state?.property, action: action), callback: state?.callback ?? BackupPrivateKeyCallbackState())
}

func BackupPrivateKeyPropertyReducer(_ state: BackupPrivateKeyPropertyState?, action: Action) -> BackupPrivateKeyPropertyState {
    var state = state ?? BackupPrivateKeyPropertyState()
    
    switch action {
    default:
        break
    }
    
    return state
}



