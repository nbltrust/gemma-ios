//
//  CustomSwitchView.swift
//  EOS
//
//  Created peng zhu on 2018/12/6.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation

@IBDesignable
class CustomSwitchView: BaseView {

    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var switchView: TKSimpleSwitch!

    override func setup() {
        super.setup()
        setupUI()
        setupSubViewEvent()
    }
    
    func setupUI() {
    }
    
    func setupSubViewEvent() {
    }
}
