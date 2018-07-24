//
//  ScreenShotAlertActions.swift
//  EOS
//
//  Created zhusongyu on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import ReSwift

//MARK: - State
struct ScreenShotAlertState: StateType {
    var isLoading = false
    var page: Int = 1
    var errorMessage:String?
    var property: ScreenShotAlertPropertyState
}

struct ScreenShotAlertPropertyState {
}

//MARK: - Action Creator
class ScreenShotAlertPropertyActionCreate {
    public typealias ActionCreator = (_ state: ScreenShotAlertState, _ store: Store<ScreenShotAlertState>) -> Action?
    
    public typealias AsyncActionCreator = (
        _ state: ScreenShotAlertState,
        _ store: Store <ScreenShotAlertState>,
        _ actionCreatorCallback: @escaping ((ActionCreator) -> Void)
        ) -> Void
}
