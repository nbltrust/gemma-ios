//
//  BaseView.swift
//  EOS
//
//  Created by peng zhu on 2018/11/1.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import UIKit
import NBLCommonModule

typealias ViewDidClickCallBack = () -> Void

class BaseView: UIView {

    @IBInspectable var needClick: Bool = false {
        didSet {
            if needClick {
                let tap = UITapGestureRecognizer.init(target: self, action: #selector(clickView))
                self.addGestureRecognizer(tap)
            }
        }
    }

    var viewDidClick: ViewDidClickCallBack?

    @objc func clickView() {
        if self.viewDidClick != nil {
            self.viewDidClick!()
        }
    }

    func setup() {
        Broadcaster.unregister(type(of: self), observer: self)
        Broadcaster.register(type(of: self), observer: self)

        updateHeight()
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
        return lastView?.bottom ?? 0
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
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            return
        }
        insertSubview(view, at: 0)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

}
