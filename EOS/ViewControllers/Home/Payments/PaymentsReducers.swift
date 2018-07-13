//
//  PaymentsReducers.swift
//  EOS
//
//  Created 朱宋宇 on 2018/7/10.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

func PaymentsReducer(action:Action, state:PaymentsState?) -> PaymentsState {
    return PaymentsState(isLoading: loadingReducer(state?.isLoading, action: action), page: pageReducer(state?.page, action: action), errorMessage: errorMessageReducer(state?.errorMessage, action: action), property: PaymentsPropertyReducer(state?.property, action: action))
}

func PaymentsPropertyReducer(_ state: PaymentsPropertyState?, action: Action) -> PaymentsPropertyState {
    var state = state ?? PaymentsPropertyState()
    
    switch action {
    case let action as FetchPaymentsRecordsListAction:
        state.payments = action.data
        let mData : [PaymentsRecordsViewModel] = convertTransferViewModel(data: action.data)
        state.data = mData
    case let action as GetLastPosAction:
        state.last_pos = action.last_pos
    default:
        break
    }
    
    return state
}

func convertTransferViewModel(data:[Payment]) -> [PaymentsRecordsViewModel] {
    
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
    
    var dataArray: [PaymentsRecordsViewModel] = []
    for payment in data{
        let isSend : Bool = payment.from == WallketManager.shared.getAccount()
        let state : Bool = payment.status.rawValue == 3
        let stateImage : UIImage? = isSend ? R.image.icIncome() : R.image.icSend()
        let address = isSend ? payment.to : payment.from
        let time = payment.time.string(withFormat: "yyyy/MM/dd HH:mm")
        let transferState = payment.status.description()
        let money = isSend ? "-" + payment.value : "+" + payment.value
        
        dataArray.append(PaymentsRecordsViewModel(stateImageName: stateImage, address: address!, time: time, transferState: transferState, money: money, transferStateBool: state, block: payment.block, memo: payment.memo, hashNumber: payment.hash.hashNano))
        
    }
    return dataArray
    
    
//    var dataArray: [PaymentsRecordsViewModel] = []
//    var payment = Payment.init()
//    payment.from = "121"
//    payment.time = Date()
//    payment.to = "342"
//    payment.value = "3.131"
//    payment.status = PaymentStatus.unconfirmed
//    var mdata:[Payment] = [payment,payment,payment]
//
//    for paymentData:Payment in mdata {
//        var paymentsRecordsViewModel = PaymentsRecordsViewModel()
//        if paymentData.to == WallketManager.shared.getAccount() {
//            paymentsRecordsViewModel.stateImageName = "icIncome"
//            paymentsRecordsViewModel.address = paymentData.from
//            paymentsRecordsViewModel.money = "+" + paymentData.value!
//        } else {
//            paymentsRecordsViewModel.stateImageName = "icSend"
//            paymentsRecordsViewModel.address = paymentData.to
//            paymentsRecordsViewModel.money = "-" + paymentData.value!
//
//        }
//        paymentsRecordsViewModel.time = paymentData.time.dateString(ofStyle: DateFormatter.Style.full)
//        if paymentData.status == PaymentStatus.unconfirmed {
//            paymentsRecordsViewModel.transferState = "\(R.string.localizable.transfer_state_time)"
//        }
//        dataArray.append(paymentsRecordsViewModel)
//
//
//    }
//    return dataArray as! [PaymentsRecordsViewModel]

}

