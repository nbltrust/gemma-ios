//
//  EOSBaseView.swift
//  EOS
//
//  Created by koofrank on 2018/9/18.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import Foundation
import NBLCommonModule

@IBDesignable
class EOSBaseView: UIControl {
    var xibView: UIView!
    var foreView: UIView!

    enum TouchAlphaValues: CGFloat {
        case touched = 0.3
        case untouched = 1.0
    }

    var touchAlpha: TouchAlphaValues = .untouched {
        didSet {
            updateTouchAlpha()
        }
    }

    var pressed: Bool = false {
        didSet {
            if !showTouchFeedback {
                return
            }

            touchAlpha = (pressed) ? .touched : .untouched
        }
    }

    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.foreView.alpha = TouchAlphaValues.touched.rawValue
            } else {
                self.foreView.alpha = self.touchAlpha.rawValue
            }
        }
    }

    let touchDisableRadius: CGFloat = 20

    @IBInspectable public var showTouchFeedback: Bool = true

    var data: Any?

    func updateUI<T>(_ model: T, handler: ((T) -> Void)?) {
        self.data = model

        handler?(model)
    }

    func setup() {
        Broadcaster.unregister(type(of: self), observer: self)
        Broadcaster.register(type(of: self), observer: self)

        updateHeight()

        setupEvent()
    }

    func setupEvent() {
        self.addTarget(self, action: #selector(didClicked), for: .touchUpInside)
    }

    @objc func didClicked() {

    }

    // MARK: Touch

    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        pressed = true
    }

    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let shouldSendActions = pressed
        pressed = false
        if shouldSendActions {
            sendActions(for: .touchUpInside)
        }
    }

    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touchLoc = touches.first?.location(in: self) {
            if (touchLoc.x < -touchDisableRadius ||
                touchLoc.y < -touchDisableRadius ||
                touchLoc.x > self.bounds.size.width + touchDisableRadius ||
                touchLoc.y > self.bounds.size.height + touchDisableRadius) {
                pressed = false
            } else if self.touchAlpha == .untouched {
                pressed = true
            }
        }
    }

    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        pressed = false
    }

    func updateTouchAlpha() {
        if self.foreView.alpha != self.touchAlpha.rawValue {
            UIView.animate(withDuration: 0.3) {
                self.foreView.alpha = self.touchAlpha.rawValue
            }
        }
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
        insertSubview(view, at: 1)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        let foreView = UIView()
        foreView.frame = self.bounds
        foreView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        foreView.backgroundColor = UIColor.white
        insertSubview(foreView, at: 0)

        self.xibView = view
        self.foreView = foreView
    }
}
