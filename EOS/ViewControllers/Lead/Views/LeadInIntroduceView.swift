//
//  LeadInIntroduceView.swift
//  EOS
//
//  Created by DKM on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit

class LeadInIntroduceView: UIView {

    enum event_name : String {
        case switchToKeyView
    }
    @IBOutlet weak var beginLeadIn: Button!
    
    override var intrinsicContentSize: CGSize {
        return CGSize.init(width: UIViewNoIntrinsicMetric,height: dynamicHeight())
    }
    
    
    
    
    func setup() {
        beginLeadIn.button.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
//        beginLeadIn.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self](tap) in
//            guard let `self` = self else { return }
//            self.beginLeadIn.next?.sendEventWith(event_name.switchToKeyView.rawValue, userinfo: ["data":""])
//        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    func updateHeight() {
        layoutIfNeeded()
        self.height = dynamicHeight()
        invalidateIntrinsicContentSize()
    }
    
    fileprivate func dynamicHeight() -> CGFloat {
        let lastView = self.subviews.last?.subviews.last
        return lastView!.bottom
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
extension LeadInIntroduceView {
    @objc func clickButton() {
        self.next?.sendEventWith(event_name.switchToKeyView.rawValue, userinfo: ["data":""])
    }
}
