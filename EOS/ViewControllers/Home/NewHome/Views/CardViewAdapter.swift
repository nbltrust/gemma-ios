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
        self.tokenLabel.text = model.tokens
        self.tokenArray = model.tokenArray
        self.otherBalanceLabel.text = model.otherBalance
        
        if model.tokenArray.count == 0 {
            self.tokenLabel.isHidden = true
            self.tokenView.isHidden = true
        }
    }
}
