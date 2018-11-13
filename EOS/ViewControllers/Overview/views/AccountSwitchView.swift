//
//  AccountSwitchView.swift
//  EOS
//
//  Created peng zhu on 2018/11/6.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation

@IBDesignable
class AccountSwitchView: BaseView {
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var dropView: UIImageView!
    
    override func setup() {
        super.setup()
        setupUI()
    }

    func setupUI() {
        self.needClick = false
    }
}
