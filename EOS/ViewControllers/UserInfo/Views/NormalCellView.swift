//
//  NormalCellView.swift
//  EOS
//
//  Created by DKM on 2018/7/18.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit

@IBDesignable
class NormalCellView: UIView {
    enum EventName: String {
        case clickCellView
    }

    enum NormalCellViewState: Int {
        case normal = 0
        case choose
        case transform
    }

    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var leftIcon: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var rightIcon: UIImageView!
    @IBOutlet weak var nameLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightIconHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightIconWidthConstraint: NSLayoutConstraint!

    @IBInspectable
    var state: Int = NormalCellViewState.normal.rawValue {
        didSet {
            switch state {
            case NormalCellViewState.normal.rawValue:
                print("")
            case NormalCellViewState.choose.rawValue:
                print("")
            case NormalCellViewState.transform.rawValue:
                self.rightIcon.isHighlighted = true
            default:
                break
            }
        }
    }

    @IBInspectable
    var index: Int = 0

    @IBInspectable
    var nameText: String? {
        didSet {
            if let text = nameText {
                name.attributedText = text.localized().set(style: nameStyle ?? "")
            }
        }
    }

    @IBInspectable
    var contentText: String? {
        didSet {
            if let text = contentText {
                content.attributedText = text.localized().set(style: contentStyle ?? "")
            }
        }
    }

    @IBInspectable
    var nameStyle: String? {
        didSet {
            let text = nameText ?? ""
            name.attributedText = text.localized().set(style: nameStyle ?? "")
        }
    }

    @IBInspectable
    var contentStyle: String? {
        didSet {
            let text = contentText ?? ""
            content.attributedText = text.localized().set(style: contentStyle ?? "")
        }
    }

    @IBInspectable
    var leftIconName: String? {
        didSet {
            if let name = leftIconName {
                if self.state != NormalCellViewState.normal.rawValue {
                    return
                }
                self.leftIcon.isHidden = false
                self.leftIcon.image = UIImage(named: name)
                nameLeftConstraint.constant = 41
            }
        }
    }

    @IBInspectable
    var rightIconName: String? {
        didSet {
            if let name = rightIconName {
                if self.state == NormalCellViewState.normal.rawValue {
                    return
                }
                self.rightIcon.image = UIImage(named: name)
                rightIconHeightConstraint.constant = 20
                rightIconWidthConstraint.constant = 20
            }
        }
    }

    @IBInspectable
    var selectBackgroundColor: UIColor = UIColor.whiteColor {
        didSet {

        }
    }

    @IBInspectable
    var isShowLineView: Bool = true {
        didSet {
            self.lineView.isHidden = !isShowLineView
        }
    }

    @IBInspectable
    var isEnable: Bool = true {
        didSet {
            self.isUserInteractionEnabled = isEnable
        }
    }

    var data: Any? {
        didSet {

        }
    }
    fileprivate var normalBgColor: UIColor? {
        didSet {

        }
    }

    func setup() {
        self.state = NormalCellViewState.normal.rawValue
    }

    func reload() {
        if let text = nameText {
            name.attributedText = text.localized().set(style: nameStyle ?? "")
        }

        if let text = contentText {
            content.attributedText = text.localized().set(style: contentStyle ?? "")
        }
    }

    override var intrinsicContentSize: CGSize {
        return CGSize.init(width: UIView.noIntrinsicMetric, height: dynamicHeight())
    }

    func updateHeight() {
        layoutIfNeeded()
        self.height = dynamicHeight()
        invalidateIntrinsicContentSize()
    }

    fileprivate func dynamicHeight() -> CGFloat {
        let lastView = self.subviews.last?.subviews.last
        return lastView!.bottom
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
        setup()
    }

    fileprivate func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nibName = String(describing: type(of: self))
        let nib = UINib.init(nibName: nibName, bundle: bundle)
        guard let  view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }

        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}

extension NormalCellView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.normalBgColor = self.subviews.last?.backgroundColor
        self.subviews.last?.backgroundColor = self.selectBackgroundColor
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.perform(#selector(becomeNormal), with: nil, afterDelay: 0.3)
        self.clickCellViewAction()
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.subviews.last?.backgroundColor = self.selectBackgroundColor
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.subviews.last?.backgroundColor = self.normalBgColor
    }

    @objc func becomeNormal() {
        self.subviews.last?.backgroundColor = self.normalBgColor
    }

    @objc func clickCellViewAction() {
        switch self.state {
        case NormalCellViewState.normal.rawValue:
            self.sendEventWith(EventName.clickCellView.rawValue, userinfo: ["index": index])
        case NormalCellViewState.choose.rawValue :
            self.sendEventWith(EventName.clickCellView.rawValue, userinfo: ["index": index])
        case NormalCellViewState.transform.rawValue:
            print("")
        default:break
        }
    }
}
