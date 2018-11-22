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
            } else {
                if !(BLTWalletIO.shareInstance()?.isConnection() ?? false) {
                    self.bluetoothStateLabel.text = desWithInfo(nil)
                    self.bluetoothImgView.image = imageWithInfo(nil)
                }
                BLTWalletIO.shareInstance()?.batteryInfoUpdated = { [weak self] (info) in
                    guard let `self` = self else { return }
                    self.bluetoothStateLabel.text = desWithInfo(info)
                    self.bluetoothImgView.image = imageWithInfo(info)
                }
            }
        }
        self.nameLabel.text = model.name
    }
}
