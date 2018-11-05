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
        self.iconImgView.image = R.image.eos()
        self.balanceLabel.text = model.total
        self.currencyLabel.text = model.name
        self.cnyLabel.text = "≈ ¥ \(model.CNY)"
    }
}
