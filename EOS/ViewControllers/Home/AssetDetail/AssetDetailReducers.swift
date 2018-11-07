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

    /*
     action_seq: 90
     from: "abcabcabcabc"
     to: "defdefdefdef"
     value: "1.0000 EOS"
     memo: "transfer to defdefdefdef"
     time: "2018-07-10T11:58:20"
     status: "1"
     hash: "577f910217393e12c2bf3d5490130cd404535e1f9f74e97a847e585ad554e0c9"
     block: 5138962

     var stateImageName : UIImage?
     var address : String = ""
     var time : String = ""
     var transferState : String = ""
     var money : String = ""
     var transferStateBool : Bool = true
     var block : String = ""
     var memo : String = ""
     var hashNumber : String = ""
     */
    var newdict = dict
    var modelArray: [PaymentsRecordsViewModel] = []
    for payment in data {
        let isSend: Bool = payment.sender == CurrencyManager.shared.getCurrentAccountName()
        let state: Bool = true//payment.status.rawValue == 3
        let stateImage: UIImage? = isSend ? R.image.icSend() : R.image.icIncome()
        let address = isSend ? payment.receiver : payment.sender
        let time = payment.timestamp.string(withFormat: "MM-dd yyyy")
        let transferState = "payment.status.description()"
        let money = isSend ? "-" + payment.quantity : "+" + payment.quantity

        if newdict.keys.contains(time) {
            modelArray = newdict[time]!
        } else {
            modelArray = []
        }
        modelArray.append(PaymentsRecordsViewModel(stateImageName: stateImage,
                                                   address: address!,
                                                   time: time,
                                                   transferState: transferState,
                                                   money: money,
                                                   transferStateBool: state,
                                                   block: 0,
                                                   memo: payment.memo,
                                                   hashNumber: payment.trxId.hashNano,
                                                   hash: payment.trxId))
        newdict[time] = modelArray
    }
    return newdict
}

