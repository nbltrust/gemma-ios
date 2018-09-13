//
//  SharpCornerTipsLabelView.swift
//  KongJianLabel
//
//  Created by 朱宋宇 on 2018/7/4.
//  Copyright © 2018年 朱宋宇. All rights reserved.
//

import UIKit

class SharpCornerTipsLabelView: UIView {
    
    @IBOutlet weak var mTextLabel: UILabel!
    
    @IBOutlet weak var mImageView: UIImageView!
    
    
    func setTextAndType(text: String) {

        self.mTextLabel.text = text
        updateHeight()
        self.mImageView.image = self.mImageView.image?.stretchableImage(withLeftCapWidth: 50, topCapHeight: 20)
        
    }
    
    fileprivate func updateHeight(){
        layoutIfNeeded()
        self.frame.size.height = dynamicHeight()
        invalidateIntrinsicContentSize()
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize.init(width: UIViewNoIntrinsicMetric, height: dynamicHeight())
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

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
