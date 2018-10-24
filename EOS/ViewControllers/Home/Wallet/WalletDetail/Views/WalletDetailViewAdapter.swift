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
        self.nameLineView.name_text = R.string.localizable.name.key.localized()
        self.nameLineView.content_text = model.name
        self.pubkeyLineView.name_text = R.string.localizable.pubkey.key.localized()
        self.pubkeyLineView.content_text = model.address
        self.batteryLineView.name_text = R.string.localizable.battery.key.localized()
        self.batteryLineView.content_text = "13%"
    }
}
