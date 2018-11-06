//
//  CardViewAdapter.swift
//  EOS
//
//  Created zhusongyu on 2018/10/16.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation
import Kingfisher

extension CardView {
    func adapterModelToCardView(_ model:NewHomeViewModel) {
        if model.bottomIsHidden == false {
            self.useBalanceLabel.text = model.balance
            self.refundLabel.text = model.recentRefundAsset
            self.cpuProgress.progress = model.cpuProgress
            self.netProgress.progress = model.netProgress
            self.ramProgress.progress = model.ramProgress
            setProgressUI(progress: cpuProgress)
            setProgressUI(progress: netProgress)
            setProgressUI(progress: ramProgress)
        }
        balanceView.isHidden = model.bottomIsHidden
        refundView.isHidden = model.bottomIsHidden
        progressView.isHidden = model.bottomIsHidden
//        self.iconImgView.kf.setImage(with: URL(string: model.currencyIcon))
        self.iconImgView.image = model.currencyIcon
        self.currencyImgView.image = model.currencyImg
        self.currencyLabel.text = model.currency
        self.accountLabel.text = model.account
        self.balanceLabel.text = model.allAssets
        self.unitLabel.text = model.unit
        self.tokenArray = model.tokenArray
        
        
        let attributedString = NSMutableAttributedString(string: "≈ ¥ \(model.CNY)", attributes: [
            .font: UIFont(name: "PingFangSC-Regular", size: 18.0)!,
            .foregroundColor: UIColor.baseColor,
            .kern: 0.0
            ])
        attributedString.addAttribute(.font, value: UIFont(name: "PingFangSC-Regular", size: 14.0)!, range: NSRange(location: 0, length: 3))
        self.otherBalanceLabel.attributedText = attributedString
        
        let attributedString2 = NSMutableAttributedString(string: "+ \(model.tokens) tokens", attributes: [
            .font: UIFont(name: "PingFangSC-Regular", size: 14.0)!,
            .foregroundColor: UIColor.baseColor,
            .kern: 0.0
            ])
        
        attributedString2.addAttribute(.font, value: UIFont(name: "PingFangSC-Regular", size: 18.0)!, range: NSRange(location: 2, length: model.tokens.count))
        self.tokenLabel.attributedText = attributedString2

        
        if model.tokenArray.count == 0 {
            self.tokenLabel.isHidden = true
            self.tokenView.isHidden = true
        }
        
        self.updateHeight()
    }
}
