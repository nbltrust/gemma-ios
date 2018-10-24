//
//  QRCodeActions.swift
//  EOS
//
//  Created peng zhu on 2018/8/1.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import ReSwift

// MARK: - State
struct QRCodeState: StateType {
    var isLoading = false
    var page: Int = 1
    var errorMessage: String?
    var property: QRCodePropertyState
}

struct QRCodePropertyState {
}

// MARK: - Action Creator
class QRCodePropertyActionCreate {
    public typealias ActionCreator = (_ state: QRCodeState, _ store: Store<QRCodeState>) -> Action?

    public typealias AsyncActionCreator = (
        _ state: QRCodeState,
        _ store: Store <QRCodeState>,
        _ actionCreatorCallback: @escaping ((ActionCreator) -> Void)
        ) -> Void
}
