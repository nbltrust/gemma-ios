//
//  PriKeyView.swift
//  EOS
//
//  Created by peng zhu on 2018/8/1.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import KRProgressHUD

@IBDesignable
class PriKeyView: UIView {
    
    enum PriKeyEvent: String {
        case savedKeySafely
    }
    
    @IBOutlet weak var firstTitleView: TitleSubTitleView!
    
    @IBOutlet weak var secondTitleView: TitleSubTitleView!
    
    @IBOutlet weak var thirdTitleView: TitleSubTitleView!
    
    @IBOutlet weak var actionButton: Button!
    
    @IBOutlet weak var keyLabel: UILabel!
    
    var priKey: String? {
        didSet {
            keyLabel.text = priKey ?? ""
        }
    }
    
    @IBAction func clickToCopyPriKey(_ sender: Any) {
        if let key = priKey {
            let pasteboard = UIPasteboard.general
            pasteboard.string = key
            KRProgressHUD.showSuccess(withMessage: R.string.localizable.have_copied())
        }
    }
    
    func setupEvent() {
        actionButton.button.addTarget(self, action: #selector(action(_:)), for: .touchUpInside)
    }
    
    @objc func action(_ sender: UIButton) {
        self.sendEventWith(PriKeyEvent.savedKeySafely.rawValue, userinfo: [:])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
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

}
