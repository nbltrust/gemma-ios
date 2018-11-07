//
//  AssetsViewAdapter.swift
//  EOS
//
//  Created zhusongyu on 2018/10/30.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation

extension AssetsView {
    func adapterModelToAssetsView(_ model:AssetViewModel) {
        self.data = model
        self.nameLabel.text = model.name
//        self.cnyLabel.text = model.CNY
        self.totalLabel.text = model.balance == "" ? "0" : model.balance
        if model.iconUrl == "" {
            if model.name == "EOS" {
                self.iconView.image = R.image.eos()
            } else {
                self.iconView.kf.setImage(with: URL(string: model.iconUrl), placeholder: R.image.icTokenUnknown())

            }
        }
    }
}
