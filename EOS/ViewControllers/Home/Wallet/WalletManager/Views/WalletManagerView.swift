//
//  WalletManagerView.swift
//  EOS
//
//  Created by zhusongyu on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation

protocol WalletManagerViewDelegate: NSObjectProtocol {
    func walletNameLabelTap(walletName: UILabel)
    func exportPrivateKeyLineViewTap(exportPrivateKey: LineView)
    func changePasswordLineViewTap(changePassword: LineView)

}

class WalletManagerView: UIView {
    
    @IBOutlet weak var walletNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var exportPrivateKeyLineView: LineView!
    @IBOutlet weak var changePasswordLineView: LineView!
    
    @IBOutlet weak var walletNameView: CornerAndShadowView!
    
    weak var delegate: WalletManagerViewDelegate?
    
    var data : Any? {
        didSet {
            
        }
    }
    
    
    func setUp() {
        setUpUI()
        setUpEvent()
        updateHeight()
    }
    
    func setUpUI() {
        exportPrivateKeyLineView.name_text = R.string.localizable.export_private_key()
        exportPrivateKeyLineView.isShowLine = true
        exportPrivateKeyLineView.content_text = ""
        exportPrivateKeyLineView.image_name = R.image.icArrow.name
        exportPrivateKeyLineView.backgroundColor = UIColor.clear
        
        changePasswordLineView.name_text = R.string.localizable.change_password()
        changePasswordLineView.content_text = ""
        changePasswordLineView.image_name = R.image.icArrow.name
        changePasswordLineView.backgroundColor = UIColor.clear


    }
    
    func setUpEvent() {
        walletNameView.isUserInteractionEnabled = true
        let nameTap = UITapGestureRecognizer.init(target: self, action: #selector(nameTapClick))
        walletNameView.addGestureRecognizer(nameTap)
        
        exportPrivateKeyLineView.isUserInteractionEnabled = true
        let exportPrivateKeyTap = UITapGestureRecognizer.init(target: self, action: #selector(exportPrivateKeyTapClick))
        exportPrivateKeyLineView.addGestureRecognizer(exportPrivateKeyTap)
        
        changePasswordLineView.isUserInteractionEnabled = true
        let changePasswordTap = UITapGestureRecognizer.init(target: self, action: #selector(changePasswordTapClick))
        changePasswordLineView.addGestureRecognizer(changePasswordTap)
        
    }
    
    @objc func nameTapClick() {
        delegate?.walletNameLabelTap(walletName: walletNameLabel)
    }
    
    @objc func exportPrivateKeyTapClick() {
        delegate?.exportPrivateKeyLineViewTap(exportPrivateKey: exportPrivateKeyLineView)
    }
    
    @objc func changePasswordTapClick() {
        delegate?.changePasswordLineViewTap(changePassword: changePasswordLineView)

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
        
        self.insertSubview(view, at: 0)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
