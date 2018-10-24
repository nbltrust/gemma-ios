//
//  ChangeWalletNameView.swift
//  EOS
//
//  Created by zhusongyu on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation

class ChangeWalletNameView: UIView {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var clearButton: UIButton!

    var text = "" {
        didSet {
            textField.text = text
        }
    }

    func setUp() {
        textField.becomeFirstResponder()
        setUpUI()
        updateHeight()
    }

    func setUpUI() {
        clearButton.isHidden = true
        textField.delegate = self
    }

    @IBAction func clearBtnClick(_ sender: Any) {
        textField.text = ""
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

        self.insertSubview(view, at: 0)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}

extension ChangeWalletNameView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.clearButton.isHidden = true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        clearButton.isHidden = false
    }
}
