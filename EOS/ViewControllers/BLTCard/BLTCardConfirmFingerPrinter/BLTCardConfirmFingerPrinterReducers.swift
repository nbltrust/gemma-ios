//
//  BLTCardConfirmFingerPrinterReducers.swift
//  EOS
//
//  Created peng zhu on 2018/9/13.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift

func BLTCardConfirmFingerPrinterReducer(action: Action, state: BLTCardConfirmFingerPrinterState?) -> BLTCardConfirmFingerPrinterState {
    let state = state ?? BLTCardConfirmFingerPrinterState()

    switch action {
    case let action as PageStateAction:
        state.pageState.accept(action.state)
    default:
        break
    }

    return state
}
