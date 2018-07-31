//
//  LeadInKeyActions.swift
//  EOS
//
//  Created DKM on 2018/7/31.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import ReSwift

//MARK: - State
struct LeadInKeyState: StateType {
    var isLoading = false
    var page: Int = 1
    var errorMessage:String?
    var property: LeadInKeyPropertyState
}

struct LeadInKeyPropertyState {
}

//MARK: - Action Creator
class LeadInKeyPropertyActionCreate {
    public typealias ActionCreator = (_ state: LeadInKeyState, _ store: Store<LeadInKeyState>) -> Action?
    
    public typealias AsyncActionCreator = (
        _ state: LeadInKeyState,
        _ store: Store <LeadInKeyState>,
        _ actionCreatorCallback: @escaping ((ActionCreator) -> Void)
        ) -> Void
}
