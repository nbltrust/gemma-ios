
//
//  numberView.swift
//  Demo
//
//  Created by DKM on 2018/7/6.
//  Copyright © 2018年 DKM. All rights reserved.
//

import UIKit

@IBDesignable
class badgeView: UIView {

    @IBOutlet weak var number: UILabel!
    
    @IBInspectable
    var numberStr : String?{
        didSet{
            number.text = numberStr
            updateHeight()
            updateView()
        }
    }
    
    func updateView(){
       
        self.layer.cornerRadius = self.height * 0.5
        self.clipsToBounds  = true
    }
    
    func updateHeight(){
        layoutIfNeeded()
        self.frame.size.height = dynamicHeight()
        if self.frame.size.width < dynamicHeight(){
            self.frame.size.width = dynamicHeight()
        }
        invalidateIntrinsicContentSize()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()
    }
    
    private func dynamicHeight() -> CGFloat {
        let view = self.subviews.last?.subviews.last
        return (view?.frame.origin.y)! + (view?.frame.size.height)!
    }
    
    override var intrinsicContentSize: CGSize {
        let height = dynamicHeight()
        if self.width <= height {
            return CGSize(width: dynamicHeight(), height: dynamicHeight())
        }else{
            return CGSize(width: UIViewNoIntrinsicMetric, height: dynamicHeight())
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXIB()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadXIB()
    }
    
    func loadXIB() {
        let bundle = Bundle(for: type(of: self))
        let nibString = String(describing: type(of: self))
        let nib = UINib(nibName: nibString, bundle: bundle)
        
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        addSubview(view)
        
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        
    }

}
