//
//  BLTCardEntryReducers.swift
//  EOS
//
//  Created peng zhu on 2018/9/13.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift

func BLTCardEntryReducer(action:Action, state:BLTCardEntryState?) -> BLTCardEntryState {
    let state = state ?? BLTCardEntryState()
        
    switch action {
    case let action as PageStateAction:
        state.pageState.accept(action.state)
    default:
        break
    }
        
    return state
}


