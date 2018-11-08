//
//  ReceiptViewAdapter.swift
//  EOS
//
//  Created zhusongyu on 2018/11/7.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation
import EFQRCode

extension ReceiptView {
    func adapterModelToReceiptView(_ model:AssetViewModel) {
        self.nameLabel.text = model.name

        if model.name == "EOS" {
            self.iconImgView.image = R.image.eos()
        } else {
            self.iconImgView.kf.setImage(with: URL(string: model.iconUrl), placeholder: R.image.icTokenUnknown())
        }
        if let currency = CurrencyManager.shared.getCurrentCurrency() {
            if currency.type == .EOS {
                let account = CurrencyManager.shared.getCurrentAccountName()
                self.copyTextView.adapterModelToCopyTextView(account)
                if let tryImage = EFQRCode.generate(
                    content: account,
                    size: EFIntSize(width: 180, height: 180)) {
                    self.qrcodeImgView.image = UIImage(cgImage: tryImage)
                }
            }
        }

    }
}
