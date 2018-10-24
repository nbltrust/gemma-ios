//
//  VoteReducers.swift
//  EOS
//
//  Created peng zhu on 2018/8/8.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

func gVoteReducer(action: Action, state: VoteState?) -> VoteState {
    return VoteState(isLoading: loadingReducer(state?.isLoading, action: action),
                     page: pageReducer(state?.page, action: action),
                     errorMessage: errorMessageReducer(state?.errorMessage, action: action),
                     property: gVotePropertyReducer(state?.property, action: action),
                     callback: state?.callback ?? VoteCallbackState())
}

func gVotePropertyReducer(_ state: VotePropertyState?, action: Action) -> VotePropertyState {
    var state = state ?? VotePropertyState()

    switch action {
    case let action as SetVoteNodeListAction:
        state.datas = action.datas
    case let action as SetDelegatedInfoAction:
        state.delagatedInfo.accept(action.info)
    case let action as SetSelIndexPathsAction:
        state.selIndexPaths = action.indexPaths
    default:
        break
    }

    return state
}
