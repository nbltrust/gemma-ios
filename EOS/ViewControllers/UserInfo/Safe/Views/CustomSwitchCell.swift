//
//  CustomSwitchCell.swift
//  EOS
//
//  Created by peng zhu on 2018/12/6.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import UIKit

class CustomSwitchCell: BaseTableViewCell {

    @IBOutlet weak var switchView: CustomSwitchView!

    var title: String? {
        didSet {
            switchView.titleLabel.text = title
        }
    }

    var isOn: Bool = false {
        didSet {
            switchView.switchView.setOn(isOn, animate: true)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
