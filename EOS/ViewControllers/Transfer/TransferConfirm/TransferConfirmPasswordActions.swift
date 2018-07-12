//
//  TransferConfirmPasswordActions.swift
//  EOS
//
//  Created 朱宋宇 on 2018/7/12.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import ReSwift

//MARK: - State
struct TransferConfirmPasswordState: StateType {
    var isLoading = false
    var page: Int = 1
    var errorMessage:String?
    var property: TransferConfirmPasswordPropertyState
}

struct TransferConfirmPasswordPropertyState {
}

//MARK: - Action Creator
class TransferConfirmPasswordPropertyActionCreate {
    public typealias ActionCreator = (_ state: TransferConfirmPasswordState, _ store: Store<TransferConfirmPasswordState>) -> Action?
    
    public typealias AsyncActionCreator = (
        _ state: TransferConfirmPasswordState,
        _ store: Store <TransferConfirmPasswordState>,
        _ actionCreatorCallback: @escaping ((ActionCreator) -> Void)
        ) -> Void
}
