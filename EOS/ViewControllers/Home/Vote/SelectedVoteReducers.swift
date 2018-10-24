//
//  SelectedVoteReducers.swift
//  EOS
//
//  Created peng zhu on 2018/8/13.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift

func SelectedVoteReducer(action: Action, state: SelectedVoteState?) -> SelectedVoteState {
    return SelectedVoteState(isLoading: loadingReducer(state?.isLoading, action: action), page: pageReducer(state?.page, action: action), errorMessage: errorMessageReducer(state?.errorMessage, action: action), property: SelectedVotePropertyReducer(state?.property, action: action), callback: state?.callback ?? SelectedVoteCallbackState())
}

func SelectedVotePropertyReducer(_ state: SelectedVotePropertyState?, action: Action) -> SelectedVotePropertyState {
    var state = state ?? SelectedVotePropertyState()

    switch action {
    case let action as SetVoteNodeListAction:
        state.datas = action.datas
    case let action as SetSelIndexPathsAction:
        state.indexPaths = action.indexPaths
    default:
        break
    }

    return state
}
