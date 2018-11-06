//
//  AssetDetailReducers.swift
//  EOS
//
//  Created zhusongyu on 2018/10/30.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift

func gAssetDetailReducer(action:Action, state:AssetDetailState?) -> AssetDetailState {
    var state = state ?? AssetDetailState()
        
    switch action {
    case let action as FetchPaymentsRecordsListAction:
        state.payments = action.data
        let mData: [String: [PaymentsRecordsViewModel]] = convertTransferViewModel(data: action.data, dict: state.data)
        state.data = mData
    case let action as GetLastPosAction:
        state.lastPos = action.lastPos
    default:
        break
    }
        
    return state
}


