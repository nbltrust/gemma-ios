//
//  ServersActions.swift
//  EOS
//
//  Created DKM on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import ReSwift

//MARK: - State
struct ServersState: StateType {
    var isLoading = false
    var page: Int = 1
    var errorMessage:String?
    var property: ServersPropertyState
}

struct ServersPropertyState {
}

//MARK: - Action Creator
class ServersPropertyActionCreate {
    public typealias ActionCreator = (_ state: ServersState, _ store: Store<ServersState>) -> Action?
    
    public typealias AsyncActionCreator = (
        _ state: ServersState,
        _ store: Store <ServersState>,
        _ actionCreatorCallback: @escaping ((ActionCreator) -> Void)
        ) -> Void
}
