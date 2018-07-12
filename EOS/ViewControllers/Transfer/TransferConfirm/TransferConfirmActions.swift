//
//  TransferConfirmActions.swift
//  EOS
//
//  Created 朱宋宇 on 2018/7/12.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import ReSwift

//MARK: - State
struct TransferConfirmState: StateType {
    var isLoading = false
    var page: Int = 1
    var errorMessage:String?
    var property: TransferConfirmPropertyState
}

struct TransferConfirmPropertyState {
}

//MARK: - Action Creator
class TransferConfirmPropertyActionCreate {
    public typealias ActionCreator = (_ state: TransferConfirmState, _ store: Store<TransferConfirmState>) -> Action?
    
    public typealias AsyncActionCreator = (
        _ state: TransferConfirmState,
        _ store: Store <TransferConfirmState>,
        _ actionCreatorCallback: @escaping ((ActionCreator) -> Void)
        ) -> Void
}
