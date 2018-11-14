//
//  WalletItemCell.swift
//  EOS
//
//  Created by peng zhu on 2018/11/14.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import UIKit

class WalletItemCell: BaseTableViewCell {

    @IBOutlet weak var itemView: WalletItemView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
