//
//  WalletView.swift
//  EOS
//
//  Created by 朱宋宇 on 2018/7/6.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation

class WalletView: UIView {
    
    @IBOutlet weak var mShadowView: UIView!
    
    @IBOutlet weak var mShadowBgImgView: UIImageView!
    
    @IBOutlet var mAccountInfoView: AccountInfoView!
    var data : Any? {
        didSet {
            mAccountInfoView.data = data
            updateHeight()
//            upDateShadowBgImgView(rect: mShadowView.frame)
        }
    }
    
    func upDateImgView(mView: UIView) {
        let image = mView.drawRectShadow(rect: mShadowView.frame)
        mShadowBgImgView.image = image
//        upDateShadowBgImgView(rect: mShadowView.frame)
    }
    
//    func upDateShadowBgImgView(rect: CGRect) {
//        let image = mView.drawRectShadow(rect: mShadowView.frame)
//        mShadowBgImgView.image = image
//    }
    
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
//        upDateShadowBgImgView(rect: mShadowView.frame)

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
//        upDateShadowBgImgView(rect: mShadowView.frame)
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
