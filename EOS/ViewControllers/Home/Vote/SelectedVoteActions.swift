//
//  SelectedVoteActions.swift
//  EOS
//
//  Created peng zhu on 2018/8/13.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import Foundation
import ReSwift

// MARK: - State
struct SelectedVoteState: StateType {
    var isLoading = false
    var page: Int = 1
    var errorMessage: String?
    var property: SelectedVotePropertyState
    var callback: SelectedVoteCallbackState
}

struct SelectedVotePropertyState {
    var datas: [NodeVoteViewModel] = []
    var indexPaths: [IndexPath] = []
}

struct SelectedVoteCallbackState {
}

// MARK: - Action Creator
class SelectedVotePropertyActionCreate {
    public typealias ActionCreator = (_ state: SelectedVoteState, _ store: Store<SelectedVoteState>) -> Action?

    public typealias AsyncActionCreator = (
        _ state: SelectedVoteState,
        _ store: Store <SelectedVoteState>,
        _ actionCreatorCallback: @escaping ((ActionCreator) -> Void)
        ) -> Void
}
