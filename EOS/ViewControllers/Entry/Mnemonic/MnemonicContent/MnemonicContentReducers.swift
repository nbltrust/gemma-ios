//
//  MnemonicContentReducers.swift
//  EOS
//
//  Created zhusongyu on 2018/9/14.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift

func MnemonicContentReducer(action:Action, state:MnemonicContentState?) -> MnemonicContentState {
    let state = state ?? MnemonicContentState()
        
    switch action {
    case let action as SetSeedsAction:
        state.seedData.accept(action.datas)
    default:
        break
    }
        
    return state
}


