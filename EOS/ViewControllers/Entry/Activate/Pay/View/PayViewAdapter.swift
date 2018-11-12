//
//  PayViewAdapter.swift
//  EOS
//
//  Created zhusongyu on 2018/9/6.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import Foundation

extension PayView {
    func adapterModelToPayView(_ model: BillModel) {
        self.cpuLabel.attributedText = setEOSSufAttributeString(model.cpu)
        self.netLabel.attributedText = setEOSSufAttributeString(model.net)
        self.ramLabel.attributedText = setEOSSufAttributeString(model.ram)
        self.rmbPriceLabel.text = model.rmb
    }

    func setEOSSufAttributeString(_ str: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: str, attributes: [
            .font: UIFont(name: "PingFangSC-Regular", size: 16.0)!,
            .foregroundColor: UIColor.baseColor,
            .kern: 0.0
            ])
        attributedString.addAttribute(.font, value: UIFont(name: "PingFangSC-Regular", size: 14.0)!, range: NSRange(location: str.count-3, length: 3))
        attributedString.addAttribute(.foregroundColor, value: UIColor.introductionColor, range: NSRange(location: str.count-3, length: 3))

        return attributedString
    }
}
