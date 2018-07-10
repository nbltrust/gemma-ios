//
//  PaymentsActions.swift
//  EOS
//
//  Created 朱宋宇 on 2018/7/10.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import ReSwift

//MARK: - State
struct PaymentsState: StateType {
    var isLoading = false
    var page: Int = 1
    var errorMessage:String?
    var property: PaymentsPropertyState
}

struct PaymentsPropertyState {
    var data : [PaymentsRecordsViewModel] = []
}

struct FetchPaymentsRecordsListAction : Action {
    var data : [Any]
}

//MARK: - ViewModel
struct PaymentsRecordsViewModel {
    var name : String = ""
    var date : String = ""
    var confirme : String = ""
    var money : String = ""
}

//MARK: - Action Creator
class PaymentsPropertyActionCreate {
    public typealias ActionCreator = (_ state: PaymentsState, _ store: Store<PaymentsState>) -> Action?
    
    public typealias AsyncActionCreator = (
        _ state: PaymentsState,
        _ store: Store <PaymentsState>,
        _ actionCreatorCallback: @escaping ((ActionCreator) -> Void)
        ) -> Void
}
