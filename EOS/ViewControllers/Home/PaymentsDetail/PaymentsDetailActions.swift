//
//  PaymentsDetailActions.swift
//  EOS
//
//  Created 朱宋宇 on 2018/7/10.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import ReSwift

//MARK: - State
struct PaymentsDetailState: StateType {
    var isLoading = false
    var page: Int = 1
    var errorMessage:String?
    var property: PaymentsDetailPropertyState
}

struct PaymentsDetailPropertyState {
}

//MARK: - Action Creator
class PaymentsDetailPropertyActionCreate {
    public typealias ActionCreator = (_ state: PaymentsDetailState, _ store: Store<PaymentsDetailState>) -> Action?
    
    public typealias AsyncActionCreator = (
        _ state: PaymentsDetailState,
        _ store: Store <PaymentsDetailState>,
        _ actionCreatorCallback: @escaping ((ActionCreator) -> Void)
        ) -> Void
}
