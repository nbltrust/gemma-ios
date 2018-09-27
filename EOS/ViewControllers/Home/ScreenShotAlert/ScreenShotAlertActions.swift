//
//  ScreenShotAlertActions.swift
//  EOS
//
//  Created zhusongyu on 2018/8/2.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import ReSwift
import RxCocoa
import HandyJSON

struct ScreenShotAlertContext: RouteContext, HandyJSON {
    init() {
        title = ""
        buttonTitle = ""
    }
    
    var imageName: String?
    var title: String
    var desc: String?
    var needCancel: Bool = false
    var buttonTitle: String
    var sureShot: CompletionCallback?
}

//MARK: - State
struct ScreenShotAlertState: BaseState {
    var pageState: BehaviorRelay<PageState> = BehaviorRelay(value: .initial)
    
    var context: BehaviorRelay<RouteContext?> = BehaviorRelay(value: nil)
}
