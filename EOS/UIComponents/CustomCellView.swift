//
//  CustomCellView.swift
//  EOS
//
//  Created peng zhu on 2018/11/1.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation

@IBDesignable
class CustomCellView: BaseView {

    @IBOutlet weak var iconView: UIImageView!

    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var subTitleLabel: UILabel!

    @IBOutlet weak var arrowView: UIImageView!

    @IBOutlet weak var lineView: UIView!

    @IBOutlet weak var iconWidth: NSLayoutConstraint!

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

    var leftIconSpacing: CGFloat = 5

    @IBInspectable var iconImage: UIImage? {
        didSet {
            iconView.image = iconImage
            if let image = iconImage {
                iconWidth.constant = image.size.width + leftIconSpacing
            } else {
                iconWidth.constant = 0
            }
        }
    }

    @IBInspectable var arrowImage: UIImage? {
        didSet {
            arrowView.image = arrowImage
        }
    }

    @IBInspectable var lineViewHidden: Bool = false {
        didSet {
            lineView.isHidden = lineViewHidden
        }
    }

    override func setup() {
        super.setup()
        setupUI()
    }

    func setupUI() {

    }
}
