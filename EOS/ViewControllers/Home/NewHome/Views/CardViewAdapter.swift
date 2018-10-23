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
//        self.iconImgView.kf.setImage(with: URL(string: model.currencyIcon))
        self.iconImgView.image = model.currencyImg
        self.currencyImgView.image = model.currencyImg
        self.currencyLabel.text = model.currency
        self.accountLabel.text = model.account
        self.balanceLabel.text = model.balance
        self.unitLabel.text = model.unit
        self.tokenArray = model.tokenArray
        
        
        let attributedString = NSMutableAttributedString(string: "≈ ¥ \(model.otherBalance)", attributes: [
            .font: UIFont(name: "PingFangSC-Regular", size: 18.0)!,
            .foregroundColor: UIColor.darkSlateBlueTwo,
            .kern: 0.0
            ])
        attributedString.addAttribute(.font, value: UIFont(name: "PingFangSC-Regular", size: 14.0)!, range: NSRange(location: 0, length: 3))
        self.otherBalanceLabel.attributedText = attributedString
        
        let attributedString2 = NSMutableAttributedString(string: "+ \(model.tokens) tokens", attributes: [
            .font: UIFont(name: "PingFangSC-Regular", size: 14.0)!,
            .foregroundColor: UIColor.darkSlateBlueTwo,
            .kern: 0.0
            ])
        
        attributedString2.addAttribute(.font, value: UIFont(name: "PingFangSC-Regular", size: 18.0)!, range: NSRange(location: 2, length: model.tokens.count))
        self.tokenLabel.attributedText = attributedString2

        
        if model.tokenArray.count == 0 {
            self.tokenLabel.isHidden = true
            self.tokenView.isHidden = true
        }
    }
}
