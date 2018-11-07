//
//  CurrencyCheckCell.swift
//  EOS
//
//  Created by peng zhu on 2018/10/30.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import UIKit

class CurrencyCheckCell: BaseTableViewCell {

    @IBOutlet weak var currencyView: CustomCheckView!

    var title: String = "" {
        didSet {
            currencyView.title = title
        }
    }

    var isChoosed: Bool = false {
        didSet {
            currencyView.isChoosed = isChoosed
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
