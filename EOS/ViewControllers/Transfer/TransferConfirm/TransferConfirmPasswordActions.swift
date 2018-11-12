//
//  TransferConfirmPasswordActions.swift
//  EOS
//
//  Created 朱宋宇 on 2018/7/12.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import ReSwift
import RxCocoa
import HandyJSON

struct TransferConfirmPasswordContext: RouteContext, HandyJSON {
    init() {

    }
    var currencyID: Int64? = 0
    var iconType = ""
    var producers: [String] = []
    var type = ""
    var receiver = ""
    var amount = ""
    var remark = ""
    var contract = ""
    var callback: ((_ priKey: String, _ vc: UIViewController) -> Void)?
    var model = AssetViewModel()
}

// MARK: - State
struct TransferConfirmPasswordState: BaseState {
    var pageState: BehaviorRelay<PageState> = BehaviorRelay(value: .initial)

    var context: BehaviorRelay<RouteContext?> = BehaviorRelay(value: nil)
}

// MARK: - Action Creator
class TransferConfirmPasswordPropertyActionCreate {
    public typealias ActionCreator = (_ state: TransferConfirmPasswordState, _ store: Store<TransferConfirmPasswordState>) -> Action?

    public typealias AsyncActionCreator = (
        _ state: TransferConfirmPasswordState,
        _ store: Store <TransferConfirmPasswordState>,
        _ actionCreatorCallback: @escaping ((ActionCreator) -> Void)
        ) -> Void
}

struct TransferInfoModel {
    var pwd: String = ""
    var account: String = ""
    var amount: String = ""
    var remark: String = ""
}
