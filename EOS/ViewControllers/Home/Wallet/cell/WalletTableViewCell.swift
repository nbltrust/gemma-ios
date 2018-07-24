//
//  WalletTableViewCell.swift
//  EOS
//
//  Created by zhusongyu on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit

class WalletTableViewCell: BaseTableViewCell {

    @IBOutlet weak var walletCellView: LineView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func setup(_ data: Any?, indexPath: IndexPath) {
        walletCellView.data = data
    }
}
