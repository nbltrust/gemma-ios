//
//  BLTDeviceCell.swift
//  EOS
//
//  Created by peng zhu on 2018/9/17.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import UIKit

class BLTDeviceCell: BaseTableViewCell {

    @IBOutlet weak var cellView: LineView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected == true {
            cellView.bgView.backgroundColor = UIColor.whiteColor
        } else {
            cellView.bgView.backgroundColor = UIColor.whiteColor
        }
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        if highlighted == true {
            cellView.bgView.backgroundColor = UIColor.whiteColor
        } else {
            cellView.bgView.backgroundColor = UIColor.whiteColor
        }
    }

    override func setup(_ data: Any?, indexPath: IndexPath) {
        cellView.data = data
    }
}
