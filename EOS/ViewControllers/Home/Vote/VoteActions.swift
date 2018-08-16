//
//  VoteActions.swift
//  EOS
//
//  Created peng zhu on 2018/8/8.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import ReSwift
import RxCocoa

//MARK: - State
struct VoteState: StateType {
    var isLoading = false
    var page: Int = 1
    var errorMessage:String?
    var property: VotePropertyState
    var callback: VoteCallbackState
}

struct VotePropertyState {
    var datas: [NodeVoteViewModel] = []
    var delagatedInfo: BehaviorRelay<DelegatedInfoModel?> = BehaviorRelay(value: nil)
}

struct VoteCallbackState {
}

struct NodeVoteViewModel {
    var name: String!
    var owner: String!
    var url: String!
    var rank: String!
    var percent: String!
}

struct DelegatedInfoModel {
    var delagetedAmount: Float = 0
}

struct SetVoteNodeListAction : Action {
    var datas : [NodeVoteViewModel]
}

struct SetDelegatedInfoAction : Action {
    var info : DelegatedInfoModel
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
