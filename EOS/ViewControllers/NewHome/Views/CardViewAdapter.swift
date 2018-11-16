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
            self.useBalanceLabel.attributedText = setEOSSufAttributeString(model.balance)
            self.refundLabel.attributedText = setEOSSufAttributeString(model.recentRefundAsset)
            self.cpuProgress.progress = model.cpuProgress
            self.netProgress.progress = model.netProgress
            self.ramProgress.progress = model.ramProgress
            setProgressUI(progress: cpuProgress)
            setProgressUI(progress: netProgress)
            setProgressUI(progress: ramProgress)
            self.tokenView.isHidden = true
        } else {
            if model.tokenArray.count == 0 {
                self.tokenLabel.isHidden = true
                self.tokenView.isHidden = true
            } else {
                self.tokenLabel.isHidden = false
                self.tokenView.isHidden = false
            }
        }
        balanceView.isHidden = model.bottomIsHidden
        refundView.isHidden = model.bottomIsHidden
        progressView.isHidden = model.bottomIsHidden
        self.iconImgView.image = model.currencyIcon
        self.currencyImgView.image = model.currencyImg
        self.currencyLabel.text = model.currency
        self.accountLabel.text = model.account
        self.balanceLabel.attributedText = setTotalEOSSufAttributeString(model.allAssets)
        self.tokenArray = model.tokenArray
        
        setAttributeString(model)

        self.updateHeight()
    }

    func setAttributeString(_ model: NewHomeViewModel) {
        let attributedString = NSMutableAttributedString(string: "≈ ¥ \(model.CNY)", attributes: [
            .font: UIFont(name: "PingFangSC-Semibold", size: 18.0)!,
            .foregroundColor: UIColor.introductionColor,
            .kern: 0.0
            ])
        attributedString.addAttribute(.font, value: UIFont(name: "PingFangSC-Regular", size: 14.0)!, range: NSRange(location: 0, length: 3))
        self.otherBalanceLabel.attributedText = attributedString

        let attributedString2 = NSMutableAttributedString(string: "+ \(model.tokens) tokens", attributes: [
            .font: UIFont(name: "PingFangSC-Regular", size: 14.0)!,
            .foregroundColor: UIColor.introductionColor,
            .kern: 0.0
            ])
        attributedString2.addAttribute(.font, value: UIFont(name: "PingFangSC-Semibold", size: 18.0)!, range: NSRange(location: 2, length: model.tokens.count))
        self.tokenLabel.attributedText = attributedString2
    }

    func setEOSSufAttributeString(_ str: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: str, attributes: [
            .font: UIFont(name: "PingFangSC-Semibold", size: 16.0)!,
            .foregroundColor: UIColor.baseColor,
            .kern: 0.0
            ])
        attributedString.addAttribute(.font, value: UIFont(name: "PingFangSC-Regular", size: 14.0)!, range: NSRange(location: str.count-3, length: 3))
        attributedString.addAttribute(.foregroundColor, value: UIColor.introductionColor, range: NSRange(location: str.count-3, length: 3))

        return attributedString
    }
    func setTotalEOSSufAttributeString(_ str: String) -> NSAttributedString {
        let str = str + " EOS"
        let attributedString = NSMutableAttributedString(string: str, attributes: [
            .font: UIFont(name: "PingFangSC-Semibold", size: 24.0)!,
            .foregroundColor: UIColor.baseColor,
            .kern: 0.0
            ])
        attributedString.addAttribute(.font, value: UIFont(name: "PingFangSC-Regular", size: 14.0)!, range: NSRange(location: str.count-3, length: 3))
        return attributedString
    }
}


