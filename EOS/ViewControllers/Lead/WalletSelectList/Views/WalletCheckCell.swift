//
//  WalletCheckCell.swift
//  EOS
//
//  Created by peng zhu on 2018/11/2.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import UIKit

class WalletCheckCell: BaseTableViewCell {

    @IBOutlet weak var walletView: CustomCheckView!
    
    var title: String = "" {
        didSet {
            walletView.title = title
        }
    }

    var isChoosed: Bool = false {
        didSet {
            walletView.isChoosed = isChoosed
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
