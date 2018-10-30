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
        self.nameLabel.text = model.name
        self.cnyLabel.text = model.CNY
        self.totalLabel.text = model.total
    }
}
