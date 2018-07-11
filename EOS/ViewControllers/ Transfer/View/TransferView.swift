//
//  TransferView.swift
//  EOS
//
//  Created by 朱宋宇 on 2018/7/11.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation

@IBDesignable
class TransferView: UIView {
    
    
    @IBOutlet weak var nextButton: Button!
    
    @IBOutlet weak var accountTextField: UITextField!
    
    @IBOutlet weak var transferContentView: TransferContentView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var reciverLabel: UILabel!
    
    func setUp() {
        self.accountTextField.delegate = self
        self.accountTextField.placeholder = R.string.localizable.account_name()
        self.reciverLabel.text = R.string.localizable.receiver()
        updateHeight()
    }

    
    override var intrinsicContentSize: CGSize {
        return CGSize.init(width: UIViewNoIntrinsicMetric,height: dynamicHeight())
    }
    
    fileprivate func updateHeight() {
        layoutIfNeeded()
        self.height = dynamicHeight()
        invalidateIntrinsicContentSize()
    }
    
    fileprivate func dynamicHeight() -> CGFloat {
        let lastView = self.subviews.last?.subviews.last
        return (lastView?.frame.origin.y)! + (lastView?.frame.size.height)!
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()
        
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
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
}

extension TransferView : UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == accountTextField {
            
            let isValid = WallketManager.shared.isValidWalletName(textField.text!)
            if isValid == false {
                self.reciverLabel.text = R.string.localizable.name_warning()
                self.reciverLabel.textColor = UIColor.scarlet
            } else {
                self.reciverLabel.text = R.string.localizable.receiver()
            }
            
            if textField.text == nil || textField.text == "" {
                self.reciverLabel.text = R.string.localizable.receiver()
            }
        }
    }
}





