//
//  AssetDetailHeadViewAdapter.swift
//  EOS
//
//  Created zhusongyu on 2018/10/30.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation

extension AssetDetailHeadView {
    func adapterModelToAssetDetailHeadView(_ model:AssetViewModel) {
        self.balanceLabel.text = model.balance
        self.currencyLabel.text = model.name

        var coin = "¥"
        if coinType() == .CNY {
            coin = "¥"
        } else {
            coin = "$"
        }

        let attributedString = NSMutableAttributedString(string: "≈ \(coin) \(model.CNY)", attributes: [
            .font: UIFont(name: "PingFangSC-Semibold", size: 18.0)!,
            .foregroundColor: UIColor.introductionColor,
            .kern: 0.0
            ])
        attributedString.addAttribute(.font, value: UIFont(name: "PingFangSC-Regular", size: 14.0)!, range: NSRange(location: 0, length: 3))
        self.cnyLabel.attributedText = attributedString

        if model.name != "EOS" {
            self.cnyLabel.isHidden = true
            self.iconImgView.kf.setImage(with: URL(string: model.iconUrl), placeholder: R.image.icTokenUnknown())
        } else {
            self.cnyLabel.isHidden = false
            self.iconImgView.image = R.image.eos()
        }
    }
}
