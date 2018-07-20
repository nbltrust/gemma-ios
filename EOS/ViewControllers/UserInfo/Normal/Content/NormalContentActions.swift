//
//  NormalContentActions.swift
//  EOS
//
//  Created DKM on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import ReSwift

//MARK: - State
struct NormalContentState: StateType {
    var isLoading = false
    var page: Int = 1
    var errorMessage:String?
    var property: NormalContentPropertyState
}

struct NormalContentPropertyState {
    var data : [String] = [String]()
}

struct SetDataAction : Action {
    var data : [String]
}

//MARK: - Action Creator
class NormalContentPropertyActionCreate {
    public typealias ActionCreator = (_ state: NormalContentState, _ store: Store<NormalContentState>) -> Action?
    
    public typealias AsyncActionCreator = (
        _ state: NormalContentState,
        _ store: Store <NormalContentState>,
        _ actionCreatorCallback: @escaping ((ActionCreator) -> Void)
        ) -> Void
}
