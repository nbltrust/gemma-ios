//
//  LineView.swift
//  Demo
//
//  Created by DKM on 2018/7/6.
//  Copyright © 2018年 DKM. All rights reserved.
//

import UIKit

@IBDesignable
class LineView: UIView {

    struct LineViewModel {
        var name: String = ""
        var content: String = ""
        var imageName: String = ""
        var nameStyle: LineViewStyleNames = .normalName
        var contentStyle: LineViewStyleNames = .normalContent
        var isBadge: Bool = false
        var contentLineNumber: Int = 1
        var isShowLineView: Bool = false
    }

    @IBOutlet weak var leftImg: UIImageView!
    @IBOutlet weak var sepatateView: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var rightImg: UIImageView!
    @IBOutlet weak var imgWidth: NSLayoutConstraint!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var imgView: UIView!

    enum Event: String {
        case rightEvent
    }

    var index: String = "" {
        didSet {

        }
    }

    @IBInspectable
    var nameStyle: String = LineViewStyleNames.normalName.rawValue {
        didSet {
            self.name.attributedText = nameText.set(style: nameStyle)
        }
    }

    @IBInspectable
    var contentStyle: String = LineViewStyleNames.normalContent.rawValue {
        didSet {
            self.content.attributedText = contentText.set(style: contentStyle)
        }
    }

    @IBInspectable
    var nameText: String = ""{
        didSet {
            self.name.attributedText = nameText.set(style: nameStyle)
        }
    }

    @IBInspectable
    var contentText: String = ""{
        didSet {
            self.content.attributedText = contentText.set(style: contentStyle)
            updateHeight()
        }
    }

    @IBInspectable
    var isShowLine: Bool = false {
        didSet {
            self.sepatateView.isHidden = !isShowLine
        }
    }

    @IBInspectable
    var imageName: String = "icCheckCircleGreen" {
        didSet {
            self.rightImg.image = UIImage.init(named: imageName)
            if imageName == " " || imageName == "" {
                imgView.isHidden = true
            }
        }
    }

    @IBInspectable
    var contentLineNumber: Int = 1 {
        didSet {
            content.numberOfLines = contentLineNumber
            if contentLineNumber >= 1 {
                content.lineBreakMode = .byTruncatingTail
            } else {
                content.lineBreakMode = .byCharWrapping
            }
        }
    }

    var data: Any? {
        didSet {
            if let data = data as? LineViewModel {
                nameText = data.name
                contentText = data.content
                nameStyle = data.nameStyle.rawValue
                if data.isBadge {

                } else {
                    contentStyle = data.contentStyle.rawValue
                }
                contentLineNumber = data.contentLineNumber
                isShowLine = data.isShowLineView
                imageName = data.imageName
            }
        }
    }

    func setup() {
        leftImg.contentMode = .left
        setupEvent()
        updateHeight()
    }

    func setupEvent() {
        rightImg.rx.tapGesture().when(.recognized).subscribe(onNext: {[weak self] _ in
            guard let `self` = self else { return }
            if self.index != "" {
                self.rightImg.next?.sendEventWith(Event.rightEvent.rawValue, userinfo: ["index": self.index])
            }
        }).disposed(by: disposeBag)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXIB()
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadXIB()
        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()
    }

    private func updateHeight() {
        layoutIfNeeded()
        self.height = dynamicHeight()
        invalidateIntrinsicContentSize()
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: dynamicHeight())
    }

    fileprivate func dynamicHeight() -> CGFloat {
        let view = self.subviews.last?.subviews.last
        return (view?.frame.origin.y)! + (view?.frame.size.height)!
    }

    func loadXIB() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib.init(nibName: String.init(describing: type(of: self)), bundle: bundle)
        guard let  view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }

        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
