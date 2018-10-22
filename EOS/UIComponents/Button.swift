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

enum ButtonStyle: Int {
    case full = 1
    case border
    case fullWhite
    case fullWhiteTwo
    case fullWhiteTwoScarlet
}

class Button: UIView {
    
    @IBOutlet weak var button: UIButton!
    
    var isEnabel: BehaviorRelay<Bool> = BehaviorRelay(value: true)
    
    @IBInspectable var locali: String? {
        didSet {
            self.button.locali = locali!
        }
    }
    
    @IBInspectable var style: Int = ButtonStyle.full.rawValue {
        didSet {
            setupUI()
        }
    }
    
    var title: String! {
        didSet {
            button.setTitle(title, for: .normal)
        }
    }
    
    func setupUI() {
        switch style {
        case ButtonStyle.border.rawValue:
            borderButton()
        case ButtonStyle.full.rawValue:
            fullButton()
        case ButtonStyle.fullWhite.rawValue:
            fullWhiteButton()
        case ButtonStyle.fullWhiteTwo.rawValue:
            fullWhiteTwoButton()
        case ButtonStyle.fullWhiteTwoScarlet.rawValue:
            fullWhiteTwoScarletButton()
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
        button.backgroundColor = UIColor.whiteTwo
        button.layer.borderColor = UIColor.cornflowerBlueTwo.cgColor
        button.layer.borderWidth = 1.0
        button.setTitleColor(UIColor.cornflowerBlue, for: .normal)
        button.isUserInteractionEnabled = true
    }
    
    fileprivate func fullButton() {
        button.backgroundColor = UIColor.cornflowerBlueTwo
        button.setTitleColor(UIColor.whiteTwo, for: .normal)
        button.layer.borderColor = UIColor.clear.cgColor
        button.isUserInteractionEnabled = true
    }
    
    fileprivate func fullWhiteButton() {
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.cornflowerBlueTwo, for: .normal)
        button.layer.borderColor = UIColor.clear.cgColor
        button.isUserInteractionEnabled = true
    }
    
    fileprivate func fullWhiteTwoButton() {
        button.backgroundColor = UIColor.whiteTwo
        button.setTitleColor(UIColor.cornflowerBlue, for: .normal)
        button.layer.borderColor = UIColor.clear.cgColor
        button.isUserInteractionEnabled = true
    }
    
    fileprivate func fullWhiteTwoScarletButton() {
        button.backgroundColor = UIColor.whiteTwo
        button.setTitleColor(UIColor.scarlet, for: .normal)
        button.layer.borderColor = UIColor.clear.cgColor
        button.isUserInteractionEnabled = true
    }
    
    fileprivate func unEnablebutton() {
        button.backgroundColor = UIColor.cloudyBlueFour
        button.setTitleColor(UIColor.whiteTwo, for: .normal)
        button.layer.borderColor = UIColor.clear.cgColor
        button.isUserInteractionEnabled = false
    }
    
    
    func setup(){
        self.setupUI()
        self.isEnabel.subscribe(onNext: {[weak self] (isEnable) in
            guard let `self` = self else { return }
            self.updateUI()
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize.init(width: UIView.noIntrinsicMetric,height: dynamicHeight())
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
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
