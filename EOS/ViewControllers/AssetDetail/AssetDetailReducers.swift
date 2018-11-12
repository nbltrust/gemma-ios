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
    case let action as RemoveAction:
        state.data.removeAll()
    default:
        break
    }
        
    return state
}

func convertTransferViewModel(data: [Payment], dict: [String: [PaymentsRecordsViewModel]]) -> [String: [PaymentsRecordsViewModel]] {
    var newdict = dict
    var modelArray: [PaymentsRecordsViewModel] = []
    for payment in data {
        let isSend: Bool = payment.sender == CurrencyManager.shared.getCurrentAccountName()
        let state: Bool = true//payment.status.rawValue == 3
        let stateImage: UIImage? = isSend ? R.image.icTabPay() : R.image.icTabIncomeDeepBlue()

        var receiver = ""
        var sender = ""
        if payment.receiver != nil {
            receiver = payment.receiver
        }
        if payment.sender != nil {
            sender = payment.sender
        }
        let address = isSend ? receiver : sender
        let time = payment.timestamp.string(withFormat: "MM-dd yyyy")
        let transferState = "已接收"
        let money = isSend ? "-" + payment.quantity : "+" + payment.quantity

        if newdict.keys.contains(time) {
            modelArray = newdict[time]!
        } else {
            modelArray = []
        }
        modelArray.append(PaymentsRecordsViewModel(stateImageName: stateImage,
                                                   address: address,
                                                   time: time,
                                                   transferState: transferState,
                                                   money: money,
                                                   transferStateBool: state,
                                                   block: 0,
                                                   memo: payment.memo,
                                                   hashNumber: payment.trxId.hashNano,
                                                   hash: payment.trxId,
                                                   isSend: isSend))
        newdict[time] = modelArray
    }
    return newdict
}

