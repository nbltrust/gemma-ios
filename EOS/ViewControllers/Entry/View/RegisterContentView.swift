//
//  RegisterContentView.swift
//  EOS
//
//  Created by peng zhu on 2018/7/4.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import SwifterSwift

class RegisterContentView: UIView {

    @IBOutlet weak var nameView: TitleTextView!
    
    @IBOutlet weak var passwordView: TitleTextView!
    
    @IBOutlet weak var passwordComfirmView: TitleTextView!
    
    @IBOutlet weak var inviteCodeView: TitleTextView!
    
    enum InputType: Int {
        case name = 1
        case password
        case comfirmPassword
        case invitationCode
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
        setupUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        nameView.setting = settingWithType(type: .name)
        nameView.textField.tag = InputType.name.rawValue
        nameView.textField.delegate = self
        nameView.delegate = self
        
        passwordView.setting = settingWithType(type: .password)
        passwordView.textField.tag = InputType.password.rawValue
        passwordView.textField.delegate = self
        passwordView.delegate = self
        
        passwordComfirmView.setting = settingWithType(type: .comfirmPassword)
        passwordComfirmView.textField.tag = InputType.comfirmPassword.rawValue
        passwordComfirmView.textField.delegate = self
        passwordComfirmView.delegate = self
        
        inviteCodeView.setting = settingWithType(type: .invitationCode)
        inviteCodeView.textField.tag = InputType.invitationCode.rawValue
        inviteCodeView.textField.delegate = self
        inviteCodeView.delegate = self
    }
    
    func settingWithType(type: InputType) -> TitleTextSetting {
        switch type {
        case .name:
            return TitleTextSetting(title: R.string.localizable.account_wallet_name(),
                                    placeholder: R.string.localizable.name_ph(),
                                    warningText: R.string.localizable.name_warning(),
                                    warningType: TextCheckWarningType.alert,
                                    showLine: true,
                                    isSecureTextEntry: false)
        case .password:
            return TitleTextSetting(title: R.string.localizable.account_setting_password(),
                                    placeholder: R.string.localizable.password_ph(),
                                    warningText: R.string.localizable.password_warning(),
                                    warningType: TextCheckWarningType.redSeal,
                                    showLine: true,
                                    isSecureTextEntry: true)
        case .comfirmPassword:
            return TitleTextSetting(title: R.string.localizable.account_comfirm_password(),
                                    placeholder: R.string.localizable.comfirm_password_ph(),
                                    warningText: R.string.localizable.comfirm_password_warning(),
                                    warningType: TextCheckWarningType.redSeal,
                                    showLine: true,
                                    isSecureTextEntry: true)
        case .invitationCode:
            return TitleTextSetting(title: R.string.localizable.account_invitationcode(),
                                    placeholder: R.string.localizable.invitationcode_ph(),
                                    warningText: R.string.localizable.invitationcode_warning(),
                                    warningType: TextCheckWarningType.redSeal,
                                    showLine: false,
                                    isSecureTextEntry: false)
        }
    }
    
    func passwordSwitch(isSelected: Bool) {
        passwordView.textField.isSecureTextEntry = !isSelected
        passwordComfirmView.textField.isSecureTextEntry = !isSelected
    }
}

extension RegisterContentView: TextFieldRightViewDelegate {
    func textActionTrigger(titleTextView: TitleTextView, selected: Bool, index: NSInteger) {
        if titleTextView == passwordView {
            if index == 0 {
                titleTextView.clearText()
            } else if index == 1 {
                passwordSwitch(isSelected: selected)
            }
        } else if titleTextView == passwordComfirmView {
            if index == 0 {
                titleTextView.clearText()
            }
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
        } else if titleTextView == passwordComfirmView {
            return [TextButtonSetting(imageName: R.image.ic_close.name,
                                      selectedImageName: R.image.ic_close.name,
                                      isShowWhenEditing: true)]
        }
        return []
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
            nameView.checkStatus = TextUIStyle.common
        case InputType.password.rawValue:
            passwordView.reloadActionViews(isEditing: false)
            passwordView.checkStatus = TextUIStyle.common
        case InputType.comfirmPassword.rawValue:
            passwordComfirmView.reloadActionViews(isEditing: false)
            passwordComfirmView.checkStatus = TextUIStyle.common
        case InputType.invitationCode.rawValue:
            inviteCodeView.reloadActionViews(isEditing: false)
            inviteCodeView.checkStatus = TextUIStyle.common
        default:
            return
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
}

