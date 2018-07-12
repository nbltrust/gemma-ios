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

    @IBOutlet weak var nameView: TitleTextfieldView!
    
    @IBOutlet weak var passwordView: TitleTextfieldView!
    
    @IBOutlet weak var passwordComfirmView: TitleTextfieldView!
    
    @IBOutlet weak var passwordPromptView: TitleTextfieldView!
    
    @IBOutlet weak var inviteCodeView: TitleTextfieldView!
    
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
        updateContentSize()
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize.init(width: UIViewNoIntrinsicMetric,height: dynamicHeight())
    }
    
    func updateContentSize() {
        self.performSelector(onMainThread: #selector(self.updateHeight), with: nil, waitUntilDone: false)
        self.performSelector(onMainThread: #selector(self.updateHeight), with: nil, waitUntilDone: false)
    }
    
    @objc fileprivate func updateHeight() {
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
        handleSetupSubView(nameView, tag: InputType.name.rawValue)
        handleSetupSubView(passwordView, tag: InputType.password.rawValue)
        handleSetupSubView(passwordComfirmView, tag: InputType.comfirmPassword.rawValue)
        handleSetupSubView(passwordPromptView, tag: InputType.passwordPrompt.rawValue)
        handleSetupSubView(inviteCodeView, tag: InputType.invitationCode.rawValue)
    }
    
    func handleSetupSubView(_ titleTextfieldView : TitleTextfieldView, tag: Int) {
        titleTextfieldView.textField.tag = tag
        titleTextfieldView.textField.delegate = self
        titleTextfieldView.delegate = self
        titleTextfieldView.datasource = self
        titleTextfieldView.updateContentSize()
    }
    
    func passwordSwitch(isSelected: Bool) {
        let tempPassword = passwordView.textField.text
        passwordView.textField.text = ""
        passwordView.textField.isSecureTextEntry = !isSelected
        passwordView.textField.text = tempPassword
        
        let tempComfirmPassword = passwordComfirmView.textField.text
        passwordComfirmView.textField.text = ""
        passwordComfirmView.textField.isSecureTextEntry = !isSelected
        passwordComfirmView.textField.text = tempComfirmPassword
    }
}

extension RegisterContentView: TitleTextFieldViewDelegate,TitleTextFieldViewDataSource {
    func textIntroduction(titleTextFieldView: TitleTextfieldView) {
        if titleTextFieldView == inviteCodeView {
            self.sendEventWith(IntroduceEvent.getInviteCode.rawValue, userinfo: [:])
        }
    }
    
    func textActionTrigger(titleTextFieldView: TitleTextfieldView, selected: Bool, index: NSInteger) {
        if titleTextFieldView == passwordView {
            if index == 0 {
                titleTextFieldView.clearText()
            } else if index == 1 {
                passwordSwitch(isSelected: selected)
            }
        } else {
            if index == 0 {
                titleTextFieldView.clearText()
            }
        }
    }
    
    func textUISetting(titleTextFieldView: TitleTextfieldView) -> TitleTextSetting {
        if titleTextFieldView == nameView {
            return TitleTextSetting(title: R.string.localizable.account_wallet_name(),
                                    placeholder: R.string.localizable.name_ph(),
                                    warningText: R.string.localizable.name_warning(),
                                    introduce: "",
                                    isShowPromptWhenEditing: true,
                                    showLine: true,
                                    isSecureTextEntry: false)
        } else if titleTextFieldView == passwordView {
            return TitleTextSetting(title: R.string.localizable.account_setting_password(),
                                    placeholder: R.string.localizable.password_ph(),
                                    warningText: R.string.localizable.password_warning(),
                                    introduce: "",
                                    isShowPromptWhenEditing: false,
                                    showLine: true,
                                    isSecureTextEntry: true)
        } else if titleTextFieldView == passwordComfirmView {
            return TitleTextSetting(title: R.string.localizable.account_comfirm_password(),
                                    placeholder: R.string.localizable.comfirm_password_ph(),
                                    warningText: R.string.localizable.comfirm_password_warning(),
                                    introduce: "",
                                    isShowPromptWhenEditing: false,
                                    showLine: true,
                                    isSecureTextEntry: true)
        } else if titleTextFieldView == passwordPromptView {
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
    
    func textActionSettings(titleTextFieldView: TitleTextfieldView) -> [TextButtonSetting] {
        if titleTextFieldView == passwordView {
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
    
    func textUnitStr(titleTextFieldView: TitleTextfieldView) -> String {
        return ""
    }
}

extension RegisterContentView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField.tag {
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
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case InputType.name.rawValue:
            nameView.reloadActionViews(isEditing: false)
            nameView.checkStatus = WallketManager.shared.isValidWalletName(textField.text!) ? TextUIStyle.common : TextUIStyle.warning
        case InputType.password.rawValue:
            passwordView.reloadActionViews(isEditing: false)
            passwordView.checkStatus = WallketManager.shared.isValidPassword(textField.text!) ? TextUIStyle.common : TextUIStyle.warning
        case InputType.comfirmPassword.rawValue:
            passwordComfirmView.reloadActionViews(isEditing: false)
            passwordComfirmView.checkStatus = WallketManager.shared.isValidComfirmPassword(textField.text!, comfirmPassword: passwordView.textField.text!) ? TextUIStyle.common : TextUIStyle.warning
        case InputType.passwordPrompt.rawValue:
            passwordPromptView.reloadActionViews(isEditing: false)
            passwordPromptView.checkStatus = TextUIStyle.common
        case InputType.invitationCode.rawValue:
            inviteCodeView.reloadActionViews(isEditing: false)
            inviteCodeView.checkStatus = (textField.text?.isEmpty)! ? TextUIStyle.warning : TextUIStyle.common
        default:
            return
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        switch textField.tag {
        case InputType.name.rawValue:
            self.sendEventWith(TextChangeEvent.walletName.rawValue, userinfo: ["content" : newText])
        case InputType.password.rawValue:
            self.sendEventWith(TextChangeEvent.walletPassword.rawValue, userinfo: ["content" : newText])
        case InputType.comfirmPassword.rawValue:
            self.sendEventWith(TextChangeEvent.walletComfirmPassword.rawValue, userinfo: ["content" : newText])
        case InputType.invitationCode.rawValue:
            self.sendEventWith(TextChangeEvent.walletInviteCode.rawValue, userinfo: ["content" : newText])
        default:
            return true
        }
        return true
    }
    
//    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
//        UIView.animate(withDuration: 0.2) {
//            if let titleTextView = textView.superview?.superview as? TitleTextView {
//                titleTextView.updateHeight()
//            }
//            self.updateHeight()
//        }
//    }
}

