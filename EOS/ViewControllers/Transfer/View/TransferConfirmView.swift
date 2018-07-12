//
//  TransferConfirmView.swift
//  EOS
//
//  Created by 朱宋宇 on 2018/7/12.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
enum TransferContentType:Int {
    case confirm = 1
    case payment
}

@IBDesignable
class TransferConfirmView: UIView {
    @IBOutlet weak var receverView: LineView!
    @IBOutlet weak var amountView: LineView!
    @IBOutlet weak var remarkView: LineView!
    @IBOutlet weak var payAccountView: LineView!
    
    func setUpType(type: TransferContentType) {
        
    }
    
    func setUp() {
        updateHeight()
    }
    
    var recever = "" {
        didSet {
            receverView.content_text = recever
        }
    }
    
    var amount = "" {
        didSet {
            amountView.content_text = recever
        }
    }
    
    var remark = "" {
        didSet {
            remarkView.content_text = recever
        }
    }
    
    var payAccount = "" {
        didSet {
            payAccountView.content_text = recever
        }
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
        return (lastView?.frame.origin.y)! + (lastView?.frame.size.height)!
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
        
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
}
