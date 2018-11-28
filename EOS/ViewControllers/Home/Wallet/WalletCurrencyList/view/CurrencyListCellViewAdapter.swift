//
//  CurrencyListCellViewAdapter.swift
//  EOS
//
//  Created zhusongyu on 2018/11/27.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation

extension CurrencyListCellView {
    func adapterModelToCurrencyListCellView(_ model:Currency) {
        self.data = model
        self.iconImgView.image = model.type.icon
        self.titleLabel.text = model.type.des
    }
}
