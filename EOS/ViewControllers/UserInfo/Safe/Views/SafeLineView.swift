//
//  SafeLineView.swift
//  EOS
//
//  Created by DKM on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit

@IBDesignable
class SafeLineView: UIView {

    enum event_name: String {
        case clickCellView
    }

    @IBOutlet weak var safeLineView: NormalCellView!

    @IBOutlet weak var safeSwitch: TKSimpleSwitch!

    @IBInspectable
    var name: String? {
        didSet {
            safeLineView.name_text = name
        }
    }

    @IBInspectable
    var isShowLineView: Bool = true {
        didSet {
            safeLineView.isShowLineView = isShowLineView
        }
    }

    @IBInspectable
    var index: Int = 0 {
        didSet {
            self.safeLineView.index = self.index
        }
    }

    @IBAction func clickSwitchAction(sender: UISwitch) {
        sender.isOn = !sender.isOn
        self.next?.sendEventWith(event_name.clickCellView.rawValue, userinfo: ["index": self.index])

    }

    override var intrinsicContentSize: CGSize {
        return CGSize.init(width: UIView.noIntrinsicMetric, height: dynamicHeight())
    }

    func setup() {
        self.safeLineView.index = self.index
        self.safeLineView.rightIcon.isHidden = true
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
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView

        insertSubview(view, at: 0)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}

extension SafeLineView {
    @objc func clickCellView(_ sender: [String: Any]) {
        self.next?.sendEventWith(event_name.clickCellView.rawValue, userinfo: sender)
    }
}
