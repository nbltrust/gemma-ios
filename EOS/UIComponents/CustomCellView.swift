//
//  CustomCellView.swift
//  EOS
//
//  Created peng zhu on 2018/11/1.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation

enum LineViewAlignment: Int {
    case toIcon = 1
    case toTitle
}

@IBDesignable
class CustomCellView: BaseView {

    @IBOutlet weak var iconView: UIImageView!

    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var subTitleLabel: UILabel!

    @IBOutlet weak var arrowView: UIImageView!

    @IBOutlet weak var lineView: UIView!

    @IBOutlet weak var leftIconMagin: NSLayoutConstraint!

    @IBOutlet weak var iconWidth: NSLayoutConstraint!

    @IBOutlet weak var leftLineMagin: NSLayoutConstraint!

    @IBOutlet weak var titleGap: NSLayoutConstraint!
    
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

    var lineViewAlignment: LineViewAlignment = .toIcon {
        didSet {
            reloadUI()
        }
    }

    var titleGapWithSubTitle: CGFloat = 0 {
        didSet {
            reloadUI()
        }
    }

    var leftIconSpacing: CGFloat = 5 {
        didSet {
            reloadUI()
        }
    }

    var leftSpacing: CGFloat = 20 {
        didSet {
            reloadUI()
        }
    }

    @IBInspectable var iconImage: UIImage? {
        didSet {
            reloadUI()
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

    func reloadUI() {
        //Icon
        iconView.image = iconImage
        if let image = iconImage {
            iconWidth.constant = image.size.width + leftIconSpacing
        } else {
            iconWidth.constant = 0
        }

        //Line
        if lineViewAlignment == .toIcon {
            leftLineMagin.constant = leftSpacing
        } else {
            leftLineMagin.constant = leftSpacing + iconWidth.constant
        }

        leftIconMagin.constant = leftSpacing

        titleGap.constant = titleGapWithSubTitle
    }
}
