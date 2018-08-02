//
//  QRCodeView.swift
//  EOS
//
//  Created by peng zhu on 2018/8/2.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import EFQRCode
import KRProgressHUD

@IBDesignable
class QRCodeView: UIView {

    enum QRCodeEvent: String {
        case savedKeySafely
    }
    
    @IBOutlet weak var firstView: TitleSubTitleView!
    
    @IBOutlet weak var secondView: TitleSubTitleView!
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var qrCodeWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var actionView: Button!
    
    var isShowQRCode: Bool = false
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()
    }
    
    func setupUI() {
        actionView.button.setTitle(buttonTitle(), for: .normal)
        actionView.button.addTarget(self, action: #selector(action(_:)), for: .touchUpInside)
    }
    
    func updateButton() {
        actionView.button.setTitle(buttonTitle(), for: .normal)
    }
    
    func buttonTitle() -> String {
        return isShowQRCode ? R.string.localizable.save_key_safe() : R.string.localizable.show_qrcode()
    }
    
    @objc func action(_ sender: UIButton) {
        if isShowQRCode {
            self.sendEventWith(QRCodeEvent.savedKeySafely.rawValue, userinfo: [:])
        } else {
            showQRCode()
        }
    }
    
    private func showQRCode() {
        let key = WalletManager.shared.priKey
        if let qrCodeImage = EFQRCode.generate(
            content: key, size: EFIntSize(width: 360, height: 360)
            ) {
            updateQrCode(qrCodeImage)
        } else {
            KRProgressHUD.showError(withMessage: R.string.localizable.qrcode_generate_failed())
        }
    }
    
    func updateQrCode(_ image: CGImage) {
        isShowQRCode = true
        qrCodeWidthConstraint.constant = 180
        imgView.image = UIImage(cgImage: image)
        updateButton()
        updateConstraintsIfNeeded()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
        setupUI()
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
