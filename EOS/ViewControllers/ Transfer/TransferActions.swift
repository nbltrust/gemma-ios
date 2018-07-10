//
//  TransferActions.swift
//  EOS
//
//  Created 朱宋宇 on 2018/7/10.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import ReSwift

//MARK: - State
struct TransferState: StateType {
    var isLoading = false
    var page: Int = 1
    var errorMessage:String?
    var property: TransferPropertyState
}

struct TransferPropertyState {
}

//MARK: - Action Creator
class TransferPropertyActionCreate {
    public typealias ActionCreator = (_ state: TransferState, _ store: Store<TransferState>) -> Action?
    
    public typealias AsyncActionCreator = (
        _ state: TransferState,
        _ store: Store <TransferState>,
        _ actionCreatorCallback: @escaping ((ActionCreator) -> Void)
        ) -> Void
}
