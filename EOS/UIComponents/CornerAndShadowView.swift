//
//  CornerAndShadowView.swift
//  EOS
//
//  Created by zhusongyu on 2018/7/16.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation

@IBDesignable
class CornerAndShadowView: UIView {

    @IBOutlet weak var cornerView: UIView!

    @IBInspectable
    var cornerRadiusInt: Int = 4 {
        didSet {
            cornerView.cornerRadius = cornerRadiusInt.cgFloat
        }
    }

    @IBInspectable
    var shadowR: Int = 4 {
        didSet {
            self.subviews.forEach { [weak self](subView) in
                guard let `self` = self else { return }
                if subView.shadowOpacity == 1 {
                    subView.shadowRadius = self.shadowR.cgFloat
                }
            }
        }
    }

    @IBInspectable
    var newShadowColor: UIColor = UIColor.duskBlue5 {
        didSet {
            self.subviews.forEach { [weak self](subView) in
                guard let `self` = self else { return }
                if subView.shadowOpacity == 1 {
                    subView.shadowColor = self.newShadowColor
                }
            }
        }
    }

    func setUp() {
        //        self.shadowView.shadowColor = UIColor.red
        //        self.shadowView.shadowOffset = CGSize(width: 1, height: 2)
        updateHeight()
    }

    func updateContentSize() {
        updateHeight()
    }

    override var intrinsicContentSize: CGSize {
        return CGSize.init(width: UIView.noIntrinsicMetric, height: dynamicHeight())
    }

    fileprivate func updateHeight() {
        layoutIfNeeded()
        self.height = dynamicHeight()
        invalidateIntrinsicContentSize()
    }

    fileprivate func dynamicHeight() -> CGFloat {
        let lastView = self.subviews.last?.subviews.last
        return lastView?.bottom ?? 0

    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()
        self.subviews.forEach { [weak self](subView) in
            guard let `self` = self else { return }
            if subView.shadowOpacity == 0 {
                subView.cornerRadius = self.cornerView.cornerRadius
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
        setUp()

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
        setUp()
    }

    fileprivate func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nibName = String(describing: type(of: self))
        let nib = UINib.init(nibName: nibName, bundle: bundle)
        guard let  view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }

        self.insertSubview(view, at: 0)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

}
