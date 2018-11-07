//
//  CustomCheckView.swift
//  EOS
//
//  Created peng zhu on 2018/11/1.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation

@IBDesignable
class CustomCheckView: BaseView {

    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var checkButton: UIButton!

    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }

    var isChoosed: Bool = false {
        didSet {
            checkButton.isSelected = isChoosed
        }
    }

    @IBInspectable var checkImage: UIImage? {
        didSet {
            checkButton.setImage(checkImage, for: .selected)
        }
    }

    @IBInspectable var unCheckImage: UIImage? {
        didSet {
            checkButton.setImage(unCheckImage, for: .normal)
        }
    }

    override func setup() {
        super.setup()
        setupUI()
    }

    func setupUI() {

    }
}
