//
//  VoteActions.swift
//  EOS
//
//  Created peng zhu on 2018/8/8.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import ReSwift

//MARK: - State
struct VoteState: StateType {
    var isLoading = false
    var page: Int = 1
    var errorMessage:String?
    var property: VotePropertyState
    var callback: VoteCallbackState
}

struct VotePropertyState {
}

struct VoteCallbackState {
}


//MARK: - Action Creator
class VotePropertyActionCreate {
    public typealias ActionCreator = (_ state: VoteState, _ store: Store<VoteState>) -> Action?
    
    public typealias AsyncActionCreator = (
        _ state: VoteState,
        _ store: Store <VoteState>,
        _ actionCreatorCallback: @escaping ((ActionCreator) -> Void)
        ) -> Void
}
