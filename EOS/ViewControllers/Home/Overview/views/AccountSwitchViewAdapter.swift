//
//  AccountSwitchViewAdapter.swift
//  EOS
//
//  Created peng zhu on 2018/11/6.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation

struct AccountSwitchModel {
    var name = ""
    var more: Bool = false
    var canClick: Bool = false
}

extension AccountSwitchView {
    func adapterModelToAccountSwitchView(_ model: AccountSwitchModel) {
        self.data = model
        nameLabel.text = model.name
        dropView.isHidden = !model.more
    }
}
