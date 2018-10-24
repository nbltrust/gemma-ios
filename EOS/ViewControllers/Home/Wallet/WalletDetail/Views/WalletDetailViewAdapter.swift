//
//  WalletDetailViewAdapter.swift
//  EOS
//
//  Created zhusongyu on 2018/10/12.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation

extension WalletDetailView {
    func adapterModelToWalletDetailView(_ model: WalletManagerModel) {
        self.data = model
        self.nameLineView.nameText = R.string.localizable.name.key.localized()
        self.nameLineView.contentText = model.name
        self.pubkeyLineView.nameText = R.string.localizable.pubkey.key.localized()
        self.pubkeyLineView.contentText = model.address
        self.batteryLineView.nameText = R.string.localizable.battery.key.localized()
        self.batteryLineView.contentText = "13%"
    }
}
