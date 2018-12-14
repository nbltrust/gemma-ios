//
//  AssetDetailReducers.swift
//  EOS
//
//  Created zhusongyu on 2018/10/30.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift
import SwiftyUserDefaults

func gAssetDetailReducer(action:Action, state:AssetDetailState?) -> AssetDetailState {
    var state = state ?? AssetDetailState()
        
    switch action {
    case let action as FetchPaymentsRecordsListAction:
        state.payments = action.data
        if state.lastPos == 1, state.data != nil, (state.data?.count)! > 0 {
            state.data!.removeAll()
        }
        let mData: [(String, [PaymentsRecordsViewModel])] = convertTransferViewModel(data: action.data, tupleArray: state.data)
        state.data = mData
    case let action as GetLastPosAction:
        if action.isRefresh == true {
            state.lastPos = 1
        } else {
            state.lastPos += 1
        }
    case let action as MBalanceFetchedAction:
        var viewmodel = state.info.value
            if let balance = action.balance.arrayValue.first?.string {
                viewmodel.balance = balance.components(separatedBy: " ")[0]
            } else {
                viewmodel.balance = "0.0000"
        }
        viewmodel.name = "EOS"
        viewmodel.contract = EOSIOContract.TokenCode
        viewmodel.CNY = calculateRMBPrice(viewmodel)
        state.info.accept(viewmodel)
    case _ as RMBPriceFetchedAction:
        var viewmodel = state.info.value
        viewmodel.name = "EOS"
        viewmodel.contract = EOSIOContract.TokenCode
        viewmodel.CNY = calculateRMBPrice(viewmodel)
        state.info.accept(viewmodel)
    case let action as ATokensFetchedAction:
        if let model = convertViewModelWithTokens(tokensJson: action.data, symbol: action.symbol) {
            state.info.accept(model)
        }
    case let action as GetBlockNumAction:
        if let data = state.data {
            if let newData = changeStatus(action: action, data: data) {
                state.data = newData
                state.statusInfo.accept(newData)
            }
        }
    default:
        break
    }
    return state
}

func changeStatus(action: GetBlockNumAction, data: [(String, [PaymentsRecordsViewModel])]) -> [(String, [PaymentsRecordsViewModel])]? {
    var blockStr = ""
    var libStr = ""
    if let status = Defaults[action.trxId] as? TransferStatus, status == .success { return nil }
    if let status = Defaults[action.trxId] as? TransferStatus, status == .fail { return nil }
    if action.status == .fail {
        Defaults[action.trxId] = TransferStatus.fail.rawValue
    } else {
        if let block = action.blockNum as? String, let lib = action.libNum as? String {
            blockStr = block
            libStr = lib
            if block.toDecimal()! > lib.toDecimal()! {
                Defaults[action.trxId] = TransferStatus.pending.rawValue
            } else {
                Defaults[action.trxId] = TransferStatus.success.rawValue
            }
        }
    }
    var newData = data
    for index in 0..<data.count {
        var tuple = data[index]
        for index2 in 0..<tuple.1.count {
            let model = tuple.1[index2]
            if model.hash == action.trxId {
                var newModel = model
                if let statusInt = Defaults[action.trxId] as? Int, let status = TransferStatus(rawValue: statusInt) {
                    newModel.transferStateBool = status
                    switch status {
                    case .fail:
                        newModel.transferState = newModel.isSend ? R.string.localizable.send_fail.key.localized() : R.string.localizable.accept_fail.key.localized()
                    case .success:
                        newModel.transferState = newModel.isSend ? R.string.localizable.send_done.key.localized() : R.string.localizable.accept_done.key.localized()
                    case .pending:
                        var dValue = blockStr.toDecimal()! - libStr.toDecimal()!
                        if dValue > 325 {
                            dValue = 325
                        }
                        let percent = (1 - dValue/325)*100
                        let percentStr = percent.string(digits: 0)
                        let sendStr = R.string.localizable.send_pending.key.localized() + "\(percentStr)%"
                        let acceptStr = R.string.localizable.accept_pending.key.localized() + "\(percentStr)%"
                        newModel.transferState = newModel.isSend ? sendStr : acceptStr
                    }
                    Defaults[action.trxId + "\(newModel.isSend)transferState"] = newModel.transferState
                }
                tuple.1.remove(at: index2)
                tuple.1.insert(newModel, at: index2)
                newData.remove(at: index)
                newData.insert((tuple.0, tuple.1), at: index)
            }
        }
    }
    return newData
}

func convertTransferViewModel(data: [Payment], tupleArray: [(String, [PaymentsRecordsViewModel])]?) -> [(String, [PaymentsRecordsViewModel])] {
    var newtupleArray = tupleArray
    for payment in data {
        let isSend: Bool = payment.sender == CurrencyManager.shared.getCurrentAccountName()
        var state: TransferStatus = .fail
        if let statusInt = Defaults[payment.trxId] as? Int, let status = TransferStatus(rawValue: statusInt) {
            state = status
        }
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
        var transferState = ""
        if let transferStateStr = Defaults[payment.trxId + "\(isSend)transferState"] as? String {
            transferState = transferStateStr
        }
        let money = isSend ? "-" + payment.quantity : "+" + payment.quantity

        var isContain = false
        if newtupleArray == nil || newtupleArray?.count == 0 {
            newtupleArray = [(time, [PaymentsRecordsViewModel(stateImageName: stateImage,
                                                              address: address,
                                                              time: time,
                                                              transferState: transferState,
                                                              money: money,
                                                              transferStateBool: state,
                                                              block: 0,
                                                              memo: payment.memo,
                                                              hashNumber: payment.trxId.hashNano,
                                                              hash: payment.trxId,
                                                              isSend: isSend)])]
            isContain = true
        } else {
            for index in 0..<newtupleArray!.count {
                let tuple = newtupleArray![index]
                if tuple.0 == time {
                    var newtuple = tuple
                    newtuple.1.append(PaymentsRecordsViewModel(stateImageName: stateImage,
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
                    newtupleArray!.remove(at: index)
                    newtupleArray!.insert(newtuple, at: index)
                    isContain = true
                    break
                }
            }
        }

        if isContain == false {
            newtupleArray!.append((time, [PaymentsRecordsViewModel(stateImageName: stateImage,
                                                                  address: address,
                                                                  time: time,
                                                                  transferState: transferState,
                                                                  money: money,
                                                                  transferStateBool: state,
                                                                  block: 0,
                                                                  memo: payment.memo,
                                                                  hashNumber: payment.trxId.hashNano,
                                                                  hash: payment.trxId,
                                                                  isSend: isSend)]))
        }
    }
    let arrayValue = newtupleArray!.sorted {
        $0.0 > $1.0
    }
    return arrayValue
}

func calculateRMBPrice(_ viewmodel: AssetViewModel) -> String {
    var price = ""
    var otherPrice = ""
    if let eos = CurrencyManager.shared.getCNYPrice() {
        price = eos
    }
    if let usd = CurrencyManager.shared.getUSDPrice() {
        otherPrice = usd
    }

    if let unit = price.toDecimal(), unit != 0, let all = viewmodel.balance.toDecimal(), all != 0 {
        let cny = unit * all
        if coinType() == .CNY {
            return cny.formatCurrency(digitNum: 2)
        } else {
            if let otherPriceDouble = otherPrice.toDecimal() {
                return (cny / otherPriceDouble).formatCurrency(digitNum: 2)
            } else {
                return "0.00"
            }
        }
    } else {
        return "0.00"
    }
}

func convertViewModelWithTokens(tokensJson: [Tokens], symbol: String) -> AssetViewModel? {
    for token in tokensJson {
        if token.symbol == symbol {
            var model = AssetViewModel()
            model.name = token.symbol
            model.iconUrl = token.logoUrl
            model.balance = token.balance
            model.contract = token.code
            return model
        }
    }
    return nil
}
