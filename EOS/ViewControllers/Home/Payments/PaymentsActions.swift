//
//  PaymentsActions.swift
//  EOS
//
//  Created 朱宋宇 on 2018/7/10.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import ReSwift
import RxSwift
import RxCocoa

// MARK: - State
struct PaymentsState: StateType {
    var isLoading = false
    var page: Int = 1
    var errorMessage: String?
    var property: PaymentsPropertyState
}

struct PaymentsPropertyState {
    var data: [PaymentsRecordsViewModel] = []
    var lastPos: Int = -1
    var payments: [Payment] = []
}

struct FetchPaymentsRecordsListAction: Action {
    var data: [Payment]
}

struct GetLastPosAction: Action {
    var lastPos: Int
}

// MARK: - ViewModel
struct PaymentsRecordsViewModel {
    var stateImageName: UIImage?
    var address: String = ""
    var time: String = ""
    var transferState: String = ""
    var money: String = ""
    var transferStateBool: Bool = true
    var block: Int = 0
    var memo: String = ""
    var hashNumber: String = ""
    var hash: String = ""
}

// MARK: - Action Creator
class PaymentsPropertyActionCreate {
    public typealias ActionCreator = (_ state: PaymentsState, _ store: Store<PaymentsState>) -> Action?

    public typealias AsyncActionCreator = (
        _ state: PaymentsState,
        _ store: Store <PaymentsState>,
        _ actionCreatorCallback: @escaping ((ActionCreator) -> Void)
        ) -> Void
}
