//
//  HomeTableCell.swift
//  EOS
//
//  Created by DKM on 2018/7/11.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit

class HomeTableCell: BaseTableViewCell {

    @IBOutlet var homeCellView: LineView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected == true {
            homeCellView.bgView.backgroundColor = UIColor.whiteColor
        } else {
            homeCellView.bgView.backgroundColor = UIColor.whiteColor
        }
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        if highlighted == true {
            homeCellView.bgView.backgroundColor = UIColor.whiteColor
        } else {
            homeCellView.bgView.backgroundColor = UIColor.whiteColor
        }
    }

    override func setup(_ data: Any?, indexPath: IndexPath) {
       homeCellView.data = data
    }
}
