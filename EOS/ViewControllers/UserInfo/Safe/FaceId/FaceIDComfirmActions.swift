//
//  FaceIDComfirmActions.swift
//  EOS
//
//  Created peng zhu on 2018/8/3.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import ReSwift

//MARK: - State
struct FaceIDComfirmState: StateType {
    var isLoading = false
    var page: Int = 1
    var errorMessage:String?
    var property: FaceIDComfirmPropertyState
}

struct FaceIDComfirmPropertyState {
}

//MARK: - Action Creator
class FaceIDComfirmPropertyActionCreate {
    public typealias ActionCreator = (_ state: FaceIDComfirmState, _ store: Store<FaceIDComfirmState>) -> Action?
    
    public typealias AsyncActionCreator = (
        _ state: FaceIDComfirmState,
        _ store: Store <FaceIDComfirmState>,
        _ actionCreatorCallback: @escaping ((ActionCreator) -> Void)
        ) -> Void
}
