//
//  WookongBioInfoCell.swift
//  EOS
//
//  Created by peng zhu on 2018/11/16.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import UIKit

class WookongBioInfoCell: BaseTableViewCell {

    @IBOutlet weak var infoView: WookongBioInfoView!
    
    var title: String? {
        didSet {
            infoView.titleLabel.text = title
        }
    }

    var subTitle: String? {
        didSet {
            infoView.subTitleLabel.text = subTitle
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
