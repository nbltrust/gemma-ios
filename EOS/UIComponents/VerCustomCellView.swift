//
//  VerCustomCellView.swift
//  EOS
//
//  Created peng zhu on 2018/11/16.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation

@IBDesignable
class VerCustomCellView: BaseView {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var subTitleLabel: UILabel!


    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }

    var subTitle: String = "" {
        didSet {
            subTitleLabel.text = subTitle
        }
    }
        
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
