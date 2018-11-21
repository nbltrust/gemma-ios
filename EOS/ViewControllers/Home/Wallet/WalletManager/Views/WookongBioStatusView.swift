//
//  WookongBioStatusView.swift
//  EOS
//
//  Created peng zhu on 2018/11/15.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation

@IBDesignable
class WookongBioStatusView: BaseView {

    @IBOutlet weak var iconView: UIImageView!

    @IBOutlet weak var desLabel: UILabel!

    @IBOutlet weak var labelWidth: NSLayoutConstraint!

    override func setup() {
        super.setup()
        
        setupUI()
        setupSubViewEvent()
    }

    var data: BLTBatteryInfo? {
        didSet {
            desLabel.text = desWithInfo(data)
            desLabel.sizeToFit()
            labelWidth.constant = desLabel.width
            iconView.image = imageWithInfo(data)
        }
    }
    
    func setupUI() {
        
    }
    
    func setupSubViewEvent() {
        
    }
}
