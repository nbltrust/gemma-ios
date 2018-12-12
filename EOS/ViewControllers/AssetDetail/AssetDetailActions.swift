//
//  AssetDetailActions.swift
//  EOS
//
//  Created zhusongyu on 2018/10/30.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation
import ReSwift
import RxCocoa
import SwiftyJSON
import HandyJSON

struct AssetDetailContext: RouteContext, HandyJSON {
    init() {}
    var model = AssetViewModel()
}

//MARK: - State
struct AssetDetailState: BaseState {
    var context: BehaviorRelay<RouteContext?> = BehaviorRelay(value: nil)
    var pageState: BehaviorRelay<PageState> = BehaviorRelay(value: .initial)
    var data: [(String, [PaymentsRecordsViewModel])]? = nil
    var lastPos: Int = 1
    var payments: [Payment] = []
    var info: BehaviorRelay<AssetViewModel> = BehaviorRelay(value: AssetViewModel())
    var cnyPrice: String = ""
    var otherPrice: String = ""
    var statusInfo: BehaviorRelay<[(String, [PaymentsRecordsViewModel])]?> = BehaviorRelay(value: nil)
}

//MARK: - Action
struct AssetDetailFetchedAction: Action {
    var data:JSON
}

struct ATokensFetchedAction: Action {
    var data:[Tokens]
    var symbol = ""
}

struct GetLastPosAction: Action {
    var lastPos: Int
    var isRefresh: Bool
}

struct GetBlockNumAction: Action {
    var blockNum: String?
    var libNum: String
    var trxId: String
    var status: TransferStatus?
}

enum TransferStatus: Int {
    case success = 1
    case fail
    case pending
}
