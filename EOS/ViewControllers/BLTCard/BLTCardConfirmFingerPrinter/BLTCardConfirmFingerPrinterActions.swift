//
//  BLTCardConfirmFingerPrinterActions.swift
//  EOS
//
//  Created peng zhu on 2018/9/13.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import Foundation
import ReSwift
import RxCocoa
import SwiftyJSON
import HandyJSON

struct BLTCardConfirmFingerPrinterContext: RouteContext, HandyJSON {
    init() {
        
    }
    
    var publicKey = WalletManager.shared.currentPubKey
    var iconType = ""
    var producers: [String] = []
    var type = ""
    var receiver = ""
    var amount = ""
    var remark = ""
    var callback: ((_ priKey:String, _ vc:UIViewController) -> Void)?
}

//MARK: - State
struct BLTCardConfirmFingerPrinterState: BaseState {
    var context: BehaviorRelay<RouteContext?> = BehaviorRelay(value: nil)

    var pageState: BehaviorRelay<PageState> = BehaviorRelay(value: .initial)
}

//MARK: - Action
struct BLTCardConfirmFingerPrinterFetchedAction: Action {
    var data:JSON
}
