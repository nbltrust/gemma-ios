//
//  NavBarViewAdapter.swift
//  EOS
//
//  Created zhusongyu on 2018/10/22.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation

extension NavBarView {
    func adapterModelToNavBarView(_ model:Wallet) {
        let isBackup = WalletManager.shared.isWalletCompleteBackup(model)
        if isBackup == false, model.type == .HD {
            self.bluetoothImgView.image = R.image.icNonBackup()
            self.bluetoothStateLabel.text = R.string.localizable.non_backup.key.localized()
            self.bluetoothImgView.isHidden = false
            self.bluetoothStateLabel.isHidden = false
        } else {
            if model.type != .bluetooth {
                self.bluetoothImgView.isHidden = true
                self.bluetoothStateLabel.isHidden = true
            }
        }
        self.nameLabel.text = model.name
    }
}
