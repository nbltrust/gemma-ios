//
//  OperationLeftView.swift
//  EOS
//
//  Created by zhusongyu on 2018/7/26.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation



class OperationLeftView: UIView {
    
    @IBOutlet weak var cpuMortgageView: TitleTextfieldView!
    @IBOutlet weak var netMortgageView: TitleTextfieldView!
    
    enum InputType: Int {
        case cpu = 1
        case net
    }
    
    enum event: String {
        case cpu
        case net
    }
    
    var data: [OperationViewModel]! {
        didSet {
            cpuMortgageView.reloadData()
            netMortgageView.reloadData()
            updateHeight()
        }
    }
    
    func setUp() {
        setupUI()
        handleSetupSubView(cpuMortgageView, tag: InputType.cpu.rawValue)
        handleSetupSubView(netMortgageView, tag: InputType.net.rawValue)
        updateHeight()
    }
    
    func setupUI() {
        cpuMortgageView.setting = TitleTextSetting(title: "cdcs", placeholder: "cd", warningText: "", introduce: "", isShowPromptWhenEditing: true, showLine: true, isSecureTextEntry: false)
    }
    
    func handleSetupSubView(_ titleTextfieldView : TitleTextfieldView, tag: Int) {
        titleTextfieldView.titleLabel.font = UIFont.cnTitleMedium
        titleTextfieldView.textField.font = UIFont.pfScR16
        titleTextfieldView.textField.tag = tag
        titleTextfieldView.textField.keyboardType = .numbersAndPunctuation
        titleTextfieldView.textField.delegate = self
        titleTextfieldView.delegate = self
        titleTextfieldView.datasource = self
        titleTextfieldView.updateContentSize()
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
        return lastView?.bottom ?? 0
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
        //        self.insertSubview(view, at: 0)
        
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}

extension OperationLeftView: TitleTextFieldViewDelegate,TitleTextFieldViewDataSource {
    func textUnitStr(titleTextFieldView: TitleTextfieldView) -> String {
        return ""
    }
    
    func textUISetting(titleTextFieldView: TitleTextfieldView) -> TitleTextSetting {
        if data != nil {
            if titleTextFieldView == cpuMortgageView {
                if let data = data[0] as? OperationViewModel {
                    return TitleTextSetting(title: data.title,
                                            placeholder: data.placeholder,
                                            warningText: data.warning,
                                            introduce: data.introduce,
                                            isShowPromptWhenEditing: data.isShowPromptWhenEditing,
                                            showLine: data.showLine,
                                            isSecureTextEntry: data.isSecureTextEntry)
                }
            } else {
                if let data = data[1] as? OperationViewModel {
                    return TitleTextSetting(title: data.title,
                                            placeholder: data.placeholder,
                                            warningText: data.warning,
                                            introduce: data.introduce,
                                            isShowPromptWhenEditing: data.isShowPromptWhenEditing,
                                            showLine: data.showLine,
                                            isSecureTextEntry: data.isSecureTextEntry)
                }
            }
        } else {
            if titleTextFieldView == cpuMortgageView {
                return TitleTextSetting(title: R.string.localizable.mortgage_cpu(),
                                        placeholder: R.string.localizable.mortgage_placeholder(),
                                        warningText: "",
                                        introduce: "",
                                        isShowPromptWhenEditing: true,
                                        showLine: true,
                                        isSecureTextEntry: false)
            } else {
                return TitleTextSetting(title: R.string.localizable.mortgage_net(),
                                        placeholder: R.string.localizable.mortgage_placeholder(),
                                        warningText: "",
                                        introduce: "",
                                        isShowPromptWhenEditing: true,
                                        showLine: false,
                                        isSecureTextEntry: false)
            }
        }
    }
    
    func textIntroduction(titleTextFieldView: TitleTextfieldView) {
        
    }
    
    func textActionTrigger(titleTextFieldView: TitleTextfieldView, selected: Bool, index: NSInteger) {
        titleTextFieldView.clearText()
    }
    
    func textActionSettings(titleTextFieldView: TitleTextfieldView) -> [TextButtonSetting] {
        return [TextButtonSetting(imageName: R.image.ic_close.name,
                                  selectedImageName: R.image.ic_close.name,
                                  isShowWhenEditing: true)]
    }
}

extension OperationLeftView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField.tag {
        case InputType.cpu.rawValue:
            cpuMortgageView.reloadActionViews(isEditing: true)
            cpuMortgageView.checkStatus = TextUIStyle.highlight
        case InputType.net.rawValue:
            netMortgageView.reloadActionViews(isEditing: true)
            netMortgageView.checkStatus = TextUIStyle.highlight
        default:
            return
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case InputType.cpu.rawValue:
            if textField.text == "" {
                cpuMortgageView.checkStatus = TextUIStyle.common
            }
            cpuMortgageView.reloadActionViews(isEditing: false)
            self.sendEventWith(event.cpu.rawValue, userinfo: ["cputextfieldview":cpuMortgageView, "nettextfieldview":netMortgageView])
            self.sendEventWith(event.net.rawValue, userinfo: ["cputextfieldview":cpuMortgageView, "nettextfieldview":netMortgageView])
        case InputType.net.rawValue:
            if textField.text == "" {
                netMortgageView.checkStatus = TextUIStyle.common
            }
            netMortgageView.reloadActionViews(isEditing: false)
            self.sendEventWith(event.cpu.rawValue, userinfo: ["cputextfieldview":cpuMortgageView, "nettextfieldview":netMortgageView])
            self.sendEventWith(event.net.rawValue, userinfo: ["cputextfieldview":cpuMortgageView, "nettextfieldview":netMortgageView])
        default:
            return
        }
    }
}
