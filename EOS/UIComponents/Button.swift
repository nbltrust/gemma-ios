//
//  Button.swift
//  EOS
//
//  Created by peng zhu on 2018/7/9.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public enum ButtonStyle: Int {
    case full = 1

    case border
}

class Button: UIView {

    @IBOutlet weak var button: UIButton!

    var isEnabel: BehaviorRelay<Bool> = BehaviorRelay(value: true)

    @IBInspectable var locali: String? {
        didSet {
            self.button.setTitle(locali?.localized(), for: .normal)
        }
    }

    @IBInspectable var style: Int = ButtonStyle.full.rawValue {
        didSet {
            setupUI()
        }
    }

    @IBInspectable var image: UIImage? {
        didSet {
            button.setImage(image, for: .normal)
        }
    }

    @IBInspectable var newCornerRadius: CGFloat = 22 {
        didSet {
            button.cornerRadius = newCornerRadius
        }
    }

    var title: String! {
        didSet {
            button.setTitle(title, for: .normal)
        }
    }

    var btnBorderColor: UIColor = UIColor.baseColor {
        didSet {
            updateUI()
        }
    }

    func setupUI() {
        switch style {
        case ButtonStyle.border.rawValue:
            borderButton()
        case ButtonStyle.full.rawValue:
            fullButton()
        default:
            return
        }
    }

    func updateUI() {
        if isEnabel.value {
            setupUI()
        } else {
            unEnablebutton()
        }
    }

    fileprivate func borderButton() {
        button.backgroundColor = UIColor.whiteColor
        button.layer.borderColor = btnBorderColor.cgColor
        button.layer.borderWidth = 1.0
        button.setTitleColor(btnBorderColor, for: .normal)
        button.isUserInteractionEnabled = true
    }

    fileprivate func fullButton() {
        button.backgroundColor = UIColor.baseColor
        button.setTitleColor(UIColor.whiteColor, for: .normal)
        button.layer.borderColor = UIColor.clear.cgColor
        button.isUserInteractionEnabled = true
    }

    fileprivate func unEnablebutton() {
        button.backgroundColor = UIColor.unableColor
        button.setTitleColor(UIColor.whiteColor, for: .normal)
        button.layer.borderColor = UIColor.clear.cgColor
        button.isUserInteractionEnabled = false
    }

    func setup() {
        self.setupUI()
        self.isEnabel.subscribe(onNext: {[weak self] (_) in
            guard let `self` = self else { return }
            self.updateUI()
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
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
