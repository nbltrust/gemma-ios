//
//  OperationRightView.swift
//  EOS
//
//  Created by zhusongyu on 2018/7/26.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation

class OperationRightView: UIView {
 
    @IBOutlet weak var cpuMortgageCancelView: TitleTextfieldView!
    @IBOutlet weak var netMortgageCancelView: TitleTextfieldView!
    
    enum InputType: Int {
        case cpu = 1
        case net
    }
    
    enum event: String {
        case cpucancel
        case netcancel
    }
    
    var data: [OperationViewModel]! {
        didSet {
            cpuMortgageCancelView.reloadData()
            netMortgageCancelView.reloadData()
            updateHeight()
        }
    }
    
    func setUp() {
        handleSetupSubView(cpuMortgageCancelView, tag: InputType.cpu.rawValue)
        handleSetupSubView(netMortgageCancelView, tag: InputType.net.rawValue)
        updateHeight()
    }
    
    func handleSetupSubView(_ titleTextfieldView : TitleTextfieldView, tag: Int) {
        titleTextfieldView.titleLabel.font = UIFont.cnTitleMedium
        titleTextfieldView.textField.font = UIFont.pfScR16
        titleTextfieldView.textField.tag = tag
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

extension OperationRightView: TitleTextFieldViewDelegate,TitleTextFieldViewDataSource {
    func textUnitStr(titleTextFieldView: TitleTextfieldView) -> String {
        return ""
    }
    
    func textUISetting(titleTextFieldView: TitleTextfieldView) -> TitleTextSetting {
        if data != nil {
            if titleTextFieldView == cpuMortgageCancelView {
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
            if titleTextFieldView == cpuMortgageCancelView {
                return TitleTextSetting(title: R.string.localizable.cpu(),
                                        placeholder: R.string.localizable.mortgage_cancel_placeholder(),
                                        warningText: "",
                                        introduce: "",
                                        isShowPromptWhenEditing: true,
                                        showLine: true,
                                        isSecureTextEntry: false)
            } else {
                return TitleTextSetting(title: R.string.localizable.net(),
                                        placeholder: R.string.localizable.mortgage_cancel_placeholder(),
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

extension OperationRightView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField.tag {
        case InputType.cpu.rawValue:
            cpuMortgageCancelView.reloadActionViews(isEditing: true)
            cpuMortgageCancelView.checkStatus = TextUIStyle.highlight
        case InputType.net.rawValue:
            netMortgageCancelView.reloadActionViews(isEditing: true)
            netMortgageCancelView.checkStatus = TextUIStyle.highlight
        default:
            return
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case InputType.cpu.rawValue:
            cpuMortgageCancelView.reloadActionViews(isEditing: false)
            self.sendEventWith(event.cpucancel.rawValue, userinfo: ["cputextfieldview":cpuMortgageCancelView, "nettextfieldview":netMortgageCancelView])
            self.sendEventWith(event.netcancel.rawValue, userinfo: ["cputextfieldview":cpuMortgageCancelView, "nettextfieldview":netMortgageCancelView])
        case InputType.net.rawValue:
            netMortgageCancelView.reloadActionViews(isEditing: false)
            self.sendEventWith(event.cpucancel.rawValue, userinfo: ["cputextfieldview":cpuMortgageCancelView, "nettextfieldview":netMortgageCancelView])
            self.sendEventWith(event.netcancel.rawValue, userinfo: ["cputextfieldview":cpuMortgageCancelView, "nettextfieldview":netMortgageCancelView])

        default:
            return
        }
    }
}
