//
//  TransferContentView.swift
//  EOS
//
//  Created by 朱宋宇 on 2018/7/11.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation

@IBDesignable

class TransferContentView: UIView {
    
    @IBOutlet weak var accountTitleTextView: TitleTextView!
    
    @IBOutlet weak var moneyTitleTextView: TitleTextView!
    
    @IBOutlet weak var remarkTitleTextView: TitleTextView!
    
    enum InputType: Int {
        case account = 1
        case money
        case remark
    }
    
    func setUp() {
//        accountTitleTextView.textField.tag = InputType.account.rawValue
//        accountTitleTextView.textField.delegate = self
//        accountTitleTextView.delegate = self
//        accountTitleTextView.datasource = self
//
//        moneyTitleTextView.textField.tag = InputType.money.rawValue
//        moneyTitleTextView.textField.delegate = self
//        moneyTitleTextView.delegate = self
//        moneyTitleTextView.datasource = self
//
//        remarkTitleTextView.textField.tag = InputType.remark.rawValue
//        remarkTitleTextView.textField.delegate = self
//        remarkTitleTextView.delegate = self
//        remarkTitleTextView.datasource = self
        
        
//        accountTitleTextView.titleLabel.text = R.string.localizable.payment_account()
//        accountTitleTextView.titleLabel.font = UIFont.systemFont(ofSize: 14)
//
//        moneyTitleTextView.titleLabel.text = R.string.localizable.money()
//        moneyTitleTextView.titleLabel.font = UIFont.systemFont(ofSize: 14)
//        moneyTitleTextView.textField.placeholder = R.string.localizable.input_transfer_money()
//
//        remarkTitleTextView.titleLabel.text = R.string.localizable.remark()
//        remarkTitleTextView.titleLabel.font = UIFont.systemFont(ofSize: 14)
//        remarkTitleTextView.textField.placeholder = R.string.localizable.input_transfer_remark()
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

//extension TransferContentView: TitleTextViewDelegate,TitleTextViewDataSource {
//    func textIntroduction(titletextView: TitleTextView) {
//        if titletextView == inviteCodeView {
//            
//        }
//    }
//    
//    func textActionTrigger(titleTextView: TitleTextView, selected: Bool, index: NSInteger) {
//        if titleTextView == passwordView {
//            if index == 0 {
//                titleTextView.clearText()
//            } else if index == 1 {
//                passwordSwitch(isSelected: selected)
//            }
//        } else {
//            if index == 0 {
//                titleTextView.clearText()
//            }
//        }
//    }
//    
//    func textUISetting(titleTextView: TitleTextView) -> TitleTextSetting {
//        if titleTextView == nameView {
//            return TitleTextSetting(title: R.string.localizable.account_wallet_name(),
//                                    placeholder: R.string.localizable.name_ph(),
//                                    warningText: R.string.localizable.name_warning(),
//                                    introduce: "",
//                                    isShowPromptWhenEditing: true,
//                                    showLine: true,
//                                    isSecureTextEntry: false)
//        } else if titleTextView == passwordView {
//            return TitleTextSetting(title: R.string.localizable.account_setting_password(),
//                                    placeholder: R.string.localizable.password_ph(),
//                                    warningText: R.string.localizable.password_warning(),
//                                    introduce: "",
//                                    isShowPromptWhenEditing: false,
//                                    showLine: true,
//                                    isSecureTextEntry: true)
//        } else if titleTextView == passwordComfirmView {
//            return TitleTextSetting(title: R.string.localizable.account_comfirm_password(),
//                                    placeholder: R.string.localizable.comfirm_password_ph(),
//                                    warningText: R.string.localizable.comfirm_password_warning(),
//                                    introduce: "",
//                                    isShowPromptWhenEditing: false,
//                                    showLine: true,
//                                    isSecureTextEntry: true)
//        } else if titleTextView == passwordPromptView {
//            return TitleTextSetting(title: R.string.localizable.account_password_prompt(),
//                                    placeholder: R.string.localizable.password_prompt_ph(),
//                                    warningText: "",
//                                    introduce: "",
//                                    isShowPromptWhenEditing: false,
//                                    showLine: true,
//                                    isSecureTextEntry: false)
//        } else {
//            return TitleTextSetting(title: R.string.localizable.account_invitationcode(),
//                                    placeholder: R.string.localizable.invitationcode_ph(),
//                                    warningText: R.string.localizable.invitationcode_warning(),
//                                    introduce: R.string.localizable.invitationcode_introduce(),
//                                    isShowPromptWhenEditing: false,
//                                    showLine: false,
//                                    isSecureTextEntry: false)
//        }
//    }
//    
//    func textActionSettings(titleTextView: TitleTextView) -> [TextButtonSetting] {
//        if titleTextView == passwordView {
//            return [TextButtonSetting(imageName: R.image.ic_close.name,
//                                      selectedImageName: R.image.ic_close.name,
//                                      isShowWhenEditing: true),
//                    TextButtonSetting(imageName: R.image.ic_visible.name,
//                                      selectedImageName: R.image.ic_invisible.name,
//                                      isShowWhenEditing: false)]
//        } else {
//            return [TextButtonSetting(imageName: R.image.ic_close.name,
//                                      selectedImageName: R.image.ic_close.name,
//                                      isShowWhenEditing: true)]
//        }
//    }
//}


