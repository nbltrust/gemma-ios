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
        if selected == true {
            walletCellView.bgView.backgroundColor = UIColor.cornflowerBlue
            walletCellView.nameStyle = LineViewStyleNames.selectName.rawValue
        } else {
            walletCellView.nameStyle = LineViewStyleNames.normalName.rawValue
            walletCellView.bgView.backgroundColor = UIColor.whiteTwo
        }
        // Configure the view for the selected state
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        if self.isSelected {
            return
        }
        if highlighted == true {
            walletCellView.bgView.backgroundColor = UIColor.cornflowerBlue
            walletCellView.nameStyle = LineViewStyleNames.selectName.rawValue
        } else {
            walletCellView.nameStyle = LineViewStyleNames.normalName.rawValue
            walletCellView.bgView.backgroundColor = UIColor.whiteTwo
        }
    }

    override func setup(_ data: Any?, indexPath: IndexPath) {
        walletCellView.index = indexPath.row.string
        walletCellView.data = data
        if let newData = data as? LineView.LineViewModel, newData.name == WalletManager.shared.currentWallet()?.name {

//            self.setSelected(true, animated: true)
//            self.setHighlighted(true, animated: true)
        } else {

//            self.setSelected(false, animated: true)
//            self.setHighlighted(false, animated: true)
        }
    }
}
