//
//  SetWalletActions.swift
//  EOS
//
//  Created DKM on 2018/7/20.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import ReSwift

//MARK: - State
struct SetWalletState: StateType {
    var isLoading = false
    var page: Int = 1
    var errorMessage:String?
    var property: SetWalletPropertyState
}

struct SetWalletPropertyState {
}

//MARK: - Action Creator
class SetWalletPropertyActionCreate {
    public typealias ActionCreator = (_ state: SetWalletState, _ store: Store<SetWalletState>) -> Action?
    
    public typealias AsyncActionCreator = (
        _ state: SetWalletState,
        _ store: Store <SetWalletState>,
        _ actionCreatorCallback: @escaping ((ActionCreator) -> Void)
        ) -> Void
}
