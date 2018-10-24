//
//  BackupPrivateKeyReducers.swift
//  EOS
//
//  Created zhusongyu on 2018/8/1.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

func gBackupPrivateKeyReducer(action: Action, state: BackupPrivateKeyState?) -> BackupPrivateKeyState {
    return BackupPrivateKeyState(isLoading: loadingReducer(state?.isLoading, action: action),
                                 page: pageReducer(state?.page, action: action),
                                 errorMessage: errorMessageReducer(state?.errorMessage, action: action),
                                 property: gBackupPrivateKeyPropertyReducer(state?.property, action: action),
                                 callback: state?.callback ?? BackupPrivateKeyCallbackState())
}

func gBackupPrivateKeyPropertyReducer(_ state: BackupPrivateKeyPropertyState?, action: Action) -> BackupPrivateKeyPropertyState {
    let state = state ?? BackupPrivateKeyPropertyState()

    switch action {
    default:
        break
    }

    return state
}
