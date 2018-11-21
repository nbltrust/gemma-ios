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

    var deviceName: String? {
        didSet {
            nameLabel.text = deviceName
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
