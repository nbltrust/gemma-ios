//
//  Button.swift
//  EOS
//
//  Created by peng zhu on 2018/7/9.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit

enum ButtonStyle: Int {
    case full = 1
    case border = 2
    case unEnable = 3
}

class Button: UIView {
    
    @IBOutlet weak var button: UIButton!
    
    @IBInspectable var locali:String? {
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
        case ButtonStyle.unEnable.rawValue:
            unEnablebutton()
        default:
            return
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
    
    fileprivate func unEnablebutton() {
        button.backgroundColor = UIColor.blueyGrey
        button.setTitleColor(UIColor.whiteTwo, for: .normal)
        button.layer.borderColor = UIColor.clear.cgColor
        button.isUserInteractionEnabled = false
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
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
    
    override var intrinsicContentSize: CGSize {
        return CGSize.init(width: UIViewNoIntrinsicMetric,height: UIViewNoIntrinsicMetric)
    }
}
