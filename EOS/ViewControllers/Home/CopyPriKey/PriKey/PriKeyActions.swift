//
//  PriKeyActions.swift
//  EOS
//
//  Created peng zhu on 2018/8/1.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import ReSwift

//MARK: - State
struct PriKeyState: StateType {
    var isLoading = false
    var page: Int = 1
    var errorMessage:String?
    var property: PriKeyPropertyState
}

struct PriKeyPropertyState {
}

//MARK: - Action Creator
class PriKeyPropertyActionCreate {
    public typealias ActionCreator = (_ state: PriKeyState, _ store: Store<PriKeyState>) -> Action?
    
    public typealias AsyncActionCreator = (
        _ state: PriKeyState,
        _ store: Store <PriKeyState>,
        _ actionCreatorCallback: @escaping ((ActionCreator) -> Void)
        ) -> Void
}
