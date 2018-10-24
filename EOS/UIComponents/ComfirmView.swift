//
//  ComfirmView.swift
//  RXSwiftDemo
//
//  Created by peng zhu on 2018/6/27.
//  Copyright © 2018年 Alger. All rights reserved.
//

import UIKit

typealias ComfirmCancelHandle = () -> Void
typealias ComfirmSureHandle = () -> Void

protocol ComfirmViewProtocol {

    func showComfirmView(inView view: UIView, withTitle title: String, content: String, cancelTitle: String, sureTitle: String, cancelCompeleted: ComfirmSureHandle, sureCompleted: ComfirmSureHandle)

    func showComfirmView(inView view: UIView,
                         withTitle title: String,
                         content: String,
                         cancelTitle: String,
                         sureTitle: String,
                         isShade: Bool,
                         isTouchDismiss: Bool,
                         cancelCompeleted: ComfirmSureHandle,
                         sureCompleted: ComfirmSureHandle)
}

extension ComfirmViewProtocol where Self: UIViewController {

    func showComfirmView(inView view: UIView,
                         withTitle title: String,
                         content: String,
                         cancelTitle: String,
                         sureTitle: String,
                         cancelCompeleted: ComfirmSureHandle,
                         sureCompleted: ComfirmSureHandle) {
        showComfirmView(inView: view,
                        withTitle: title,
                        content: content,
                        cancelTitle: cancelTitle,
                        sureTitle: sureTitle,
                        isShade: true,
                        isTouchDismiss: true,
                        cancelCompeleted: cancelCompeleted,
                        sureCompleted: cancelCompeleted)
    }

    func showComfirmView(inView view: UIView,
                         withTitle title: String,
                         content: String,
                         cancelTitle: String,
                         sureTitle: String,
                         isShade: Bool,
                         isTouchDismiss: Bool,
                         cancelCompeleted: ComfirmSureHandle,
                         sureCompleted: ComfirmSureHandle) {

    }
}

@IBDesignable
class ComfirmView: UIView {

    @IBOutlet var containerView: UIView!

    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var contentLabel: UILabel!

    @IBOutlet weak var cancelButton: UIButton!

    @IBOutlet weak var sureButton: UIButton!

    enum Event: String {
        case sureEvent
    }

    @IBInspectable var title: String? {
        didSet {
            self.titleLabel.locali = title!
            updateHeight()
        }
    }

    @IBInspectable var content: String? {
        didSet {
            self.contentLabel.locali = content!
            updateHeight()
        }
    }

    @IBInspectable var cancelTitle: String? {
        didSet {
            self.cancelButton.locali = cancelTitle!
            updateHeight()
        }
    }

    @IBInspectable var sureTitle: String? {
        didSet {
            self.sureButton.locali = sureTitle!
            updateHeight()
        }
    }

    var isShade: Bool = true

    var isTouchDismiss: Bool = true

    func setup() {
        setupEvent()
        updateHeight()
    }

    func setupEvent() {
        sureButton.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] _ in
            guard let `self` = self else { return }
            self.sendEventWith(Event.sureEvent.rawValue, userinfo: [ : ])
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
        setup()
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

    fileprivate func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nibName = String(describing: type(of: self))
        let nib = UINib.init(nibName: nibName, bundle: bundle)
        guard let  view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }

        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    func setupUI(withTitle title: String, content: String, cancelTitle: String, sureTitle: String, isShade: Bool, isTouchDismiss: Bool) {
        titleLabel.text = title
        contentLabel.text = content
        cancelButton.setTitle(cancelTitle, for: .normal)
        sureButton.setTitle(sureTitle, for: .normal)
    }

}
