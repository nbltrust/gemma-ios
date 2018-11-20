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

    override func setup() {
        super.setup()
        
        setupUI()
        setupSubViewEvent()
    }

    var data: BLTBatteryInfo? {
        didSet {
            iconView.image = imageWithInfo(data)
            desLabel.text = desWithInfo(data)
        }
    }
    
    func setupUI() {
        
    }
    
    func setupSubViewEvent() {
        
    }
}
