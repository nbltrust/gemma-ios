//
//  GeneralRamCellView.swift
//  EOS
//
//  Created zhusongyu on 2018/8/9.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import Foundation

@IBDesignable
class GeneralRamCellView: UIView {
    
    @IBOutlet weak var generalView: GeneralCellView!
    @IBOutlet weak var priceLabel: UILabel!
    
    var data: Any? {
        didSet {
            if let data = data as? BuyRamViewModel {
                generalView.data = data
                priceLabel.text = data.price
            }
        }
    }
    
    fileprivate func setup() {
        updateHeight()
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
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
        setup()
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
