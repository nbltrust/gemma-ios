//
//  PayViewAdapter.swift
//  EOS
//
//  Created zhusongyu on 2018/9/6.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import Foundation

extension PayView {
    func adapterModelToPayView(_ model:BillModel) {
        self.cpuLabel.text = model.cpu
        self.netLabel.text = model.net
        self.ramLabel.text = model.ram
        self.rmbPriceLabel.text = model.rmb
    }
}
