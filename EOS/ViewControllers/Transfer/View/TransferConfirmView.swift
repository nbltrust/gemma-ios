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


class TransferConfirmView: UIView {
    @IBOutlet weak var receverLineView: LineView!
    @IBOutlet weak var moneyLineView: LineView!
    @IBOutlet weak var remarkLineView: LineView!
    @IBOutlet weak var otherLineView: LineView!
    
    func setUpType(type: TransferContentType) {
        
    }
    
    func setUp() {
        
    }
    
    var recever = "" {
        didSet {
            receverLineView.name_text = recever
        }
    }
    var receverContent = "" {
        didSet {
            receverLineView.content_text = receverContent
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
