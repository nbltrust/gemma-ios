//
//  RegisterContentView.swift
//  EOS
//
//  Created by peng zhu on 2018/7/4.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import SwifterSwift
import GrowingTextView

@IBDesignable
class RegisterContentView: UIView {

    @IBOutlet weak var nameView: TitleTextView!
    
    @IBOutlet weak var passwordView: TitleTextView!
    
    @IBOutlet weak var passwordComfirmView: TitleTextView!
    
    @IBOutlet weak var passwordPromptView: TitleTextView!
    
    @IBOutlet weak var inviteCodeView: TitleTextView!
    
    enum InputType: Int {
        case name = 1
        case password
        case comfirmPassword
        case passwordPrompt
        case invitationCode
    }
    
    enum TextChangeEvent: String {
        case walletName
        case walletPassword
        case walletComfirmPassword
        case walletInviteCode
    }
    
    enum IntroduceEvent: String {
        case getInviteCode
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
    
    func setup() {
        setupUI()
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
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight,.flexibleWidth]
    }
    
    func setupUI() {
        nameView.textView.tag = InputType.name.rawValue
        nameView.textView.delegate = self
        nameView.delegate = self
        nameView.datasource = self
        nameView.updateHeight()
        
        passwordView.textView.tag = InputType.password.rawValue
        passwordView.textView.delegate = self
        passwordView.delegate = self
        passwordView.datasource = self
        passwordView.updateHeight()

        passwordComfirmView.textView.tag = InputType.comfirmPassword.rawValue
        passwordComfirmView.textView.delegate = self
        passwordComfirmView.delegate = self
        passwordComfirmView.datasource = self
        passwordComfirmView.updateHeight()

        passwordPromptView.textView.tag = InputType.passwordPrompt.rawValue
        passwordPromptView.textView.delegate = self
        passwordPromptView.delegate = self
        passwordPromptView.datasource = self
        passwordPromptView.updateHeight()

        inviteCodeView.textView.tag = InputType.invitationCode.rawValue
        inviteCodeView.textView.delegate = self
        inviteCodeView.delegate = self
        inviteCodeView.datasource = self
        inviteCodeView.updateHeight()

    }
    
    func passwordSwitch(isSelected: Bool) {
        let tempPassword = passwordView.textView.text
        passwordView.textView.text = ""
        passwordView.textView.isSecureTextEntry = !isSelected
        passwordView.textView.text = tempPassword
        
        let tempComfirmPassword = passwordComfirmView.textView.text
        passwordComfirmView.textView.text = ""
        passwordComfirmView.textView.isSecureTextEntry = !isSelected
        passwordComfirmView.textView.text = tempComfirmPassword
    }
}

extension RegisterContentView: TitleTextViewDelegate,TitleTextViewDataSource {
    func textIntroduction(titletextView: TitleTextView) {
        if titletextView == inviteCodeView {
            self.sendEventWith(IntroduceEvent.getInviteCode.rawValue, userinfo: [:])
        }
    }
    
    func textActionTrigger(titleTextView: TitleTextView, selected: Bool, index: NSInteger) {
        if titleTextView == passwordView {
            if index == 0 {
                titleTextView.clearText()
            } else if index == 1 {
                passwordSwitch(isSelected: selected)
            }
        } else {
            if index == 0 {
                titleTextView.clearText()
            }
        }
    }
    
    func textUISetting(titleTextView: TitleTextView) -> TitleTextSetting {
        if titleTextView == nameView {
            return TitleTextSetting(title: R.string.localizable.account_wallet_name(),
                                    placeholder: R.string.localizable.name_ph(),
                                    warningText: R.string.localizable.name_warning(),
                                    introduce: "",
                                    isShowPromptWhenEditing: true,
                                    showLine: true,
                                    isSecureTextEntry: false)
        } else if titleTextView == passwordView {
            return TitleTextSetting(title: R.string.localizable.account_setting_password(),
                                    placeholder: R.string.localizable.password_ph(),
                                    warningText: R.string.localizable.password_warning(),
                                    introduce: "",
                                    isShowPromptWhenEditing: false,
                                    showLine: true,
                                    isSecureTextEntry: true)
        } else if titleTextView == passwordComfirmView {
            return TitleTextSetting(title: R.string.localizable.account_comfirm_password(),
                                    placeholder: R.string.localizable.comfirm_password_ph(),
                                    warningText: R.string.localizable.comfirm_password_warning(),
                                    introduce: "",
                                    isShowPromptWhenEditing: false,
                                    showLine: true,
                                    isSecureTextEntry: true)
        } else if titleTextView == passwordPromptView {
            return TitleTextSetting(title: R.string.localizable.account_password_prompt(),
                                    placeholder: R.string.localizable.password_prompt_ph(),
                                    warningText: "",
                                    introduce: "",
                                    isShowPromptWhenEditing: false,
                                    showLine: true,
                                    isSecureTextEntry: false)
        } else {
            return TitleTextSetting(title: R.string.localizable.account_invitationcode(),
                                    placeholder: R.string.localizable.invitationcode_ph(),
                                    warningText: R.string.localizable.invitationcode_warning(),
                                    introduce: R.string.localizable.invitationcode_introduce(),
                                    isShowPromptWhenEditing: false,
                                    showLine: false,
                                    isSecureTextEntry: false)
        }
    }
    
    func textActionSettings(titleTextView: TitleTextView) -> [TextButtonSetting] {
        if titleTextView == passwordView {
            return [TextButtonSetting(imageName: R.image.ic_close.name,
                                      selectedImageName: R.image.ic_close.name,
                                      isShowWhenEditing: true),
                    TextButtonSetting(imageName: R.image.ic_visible.name,
                                      selectedImageName: R.image.ic_invisible.name,
                                      isShowWhenEditing: false)]
        } else {
            return [TextButtonSetting(imageName: R.image.ic_close.name,
                                      selectedImageName: R.image.ic_close.name,
                                      isShowWhenEditing: true)]
        }
    }
    
    func textUnitStr(titletextView: TitleTextView) -> String {
        return ""
    }
}

extension RegisterContentView: GrowingTextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        switch textView.tag {
        case InputType.name.rawValue:
            nameView.reloadActionViews(isEditing: true)
            nameView.checkStatus = TextUIStyle.highlight
        case InputType.password.rawValue:
            passwordView.reloadActionViews(isEditing: true)
            passwordView.checkStatus = TextUIStyle.highlight
        case InputType.comfirmPassword.rawValue:
            passwordComfirmView.reloadActionViews(isEditing: true)
            passwordComfirmView.checkStatus = TextUIStyle.highlight
        case InputType.passwordPrompt.rawValue:
            passwordPromptView.reloadActionViews(isEditing: true)
            passwordPromptView.checkStatus = TextUIStyle.highlight
        case InputType.invitationCode.rawValue:
            inviteCodeView.reloadActionViews(isEditing: true)
            inviteCodeView.checkStatus = TextUIStyle.highlight
        default:
            return
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        switch textView.tag {
        case InputType.name.rawValue:
            nameView.reloadActionViews(isEditing: false)
            nameView.checkStatus = WallketManager.shared.isValidWalletName(textView.text!) ? TextUIStyle.common : TextUIStyle.warning
        case InputType.password.rawValue:
            passwordView.reloadActionViews(isEditing: false)
            passwordView.checkStatus = WallketManager.shared.isValidPassword(textView.text!) ? TextUIStyle.common : TextUIStyle.warning
        case InputType.comfirmPassword.rawValue:
            passwordComfirmView.reloadActionViews(isEditing: false)
            passwordComfirmView.checkStatus = WallketManager.shared.isValidComfirmPassword(textView.text!, comfirmPassword: passwordView.textView.text!) ? TextUIStyle.common : TextUIStyle.warning
        case InputType.passwordPrompt.rawValue:
            passwordPromptView.reloadActionViews(isEditing: false)
            passwordPromptView.checkStatus = TextUIStyle.common
        case InputType.invitationCode.rawValue:
            inviteCodeView.reloadActionViews(isEditing: false)
            inviteCodeView.checkStatus = (textView.text?.isEmpty)! ? TextUIStyle.warning : TextUIStyle.common
        default:
            return
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        switch textView.tag {
        case InputType.name.rawValue:
            self.sendEventWith(TextChangeEvent.walletName.rawValue, userinfo: ["content" : textView.text])
        case InputType.password.rawValue:
            self.sendEventWith(TextChangeEvent.walletPassword.rawValue, userinfo: ["content" : textView.text])
        case InputType.comfirmPassword.rawValue:
            self.sendEventWith(TextChangeEvent.walletComfirmPassword.rawValue, userinfo: ["content" : textView.text])
        case InputType.invitationCode.rawValue:
            self.sendEventWith(TextChangeEvent.walletInviteCode.rawValue, userinfo: ["content" : textView.text])
        default:
            return
        }
    }
    
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            if let titleTextView = textView.superview?.superview as? TitleTextView {
                titleTextView.updateHeight()
            }
            self.updateHeight()
        }
    }
}

