//
//  BLTDeviceCell.swift
//  EOS
//
//  Created by peng zhu on 2018/9/17.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import UIKit

class BLTDeviceCell: BaseTableViewCell {

    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var indicatorView: UIActivityIndicatorView!

    var deviceName: String? {
        didSet {
            nameLabel.text = deviceName
        }
    }

    func startLoading() {
        indicatorView.startAnimating()
    }

    func endLoading() {
        indicatorView.stopAnimating()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
