//
//  CardView.swift
//  EOS
//
//  Created zhusongyu on 2018/10/16.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation

@IBDesignable
class CardView: UIView {
    
    @IBOutlet weak var cornerShadowView: CornerAndShadowView!
    @IBOutlet weak var iconImgView: UIImageView!
    @IBOutlet weak var currencyImgView: UIImageView!
    @IBOutlet weak var currencyLabel: BaseLabel!
    @IBOutlet weak var accountLabel: BaseLabel!
    @IBOutlet weak var balanceLabel: BaseLabel!
    @IBOutlet weak var unitLabel: BaseLabel!
    @IBOutlet weak var tokenLabel: BaseLabel!
    @IBOutlet weak var otherBalanceLabel: BaseLabel!
    @IBOutlet weak var shadeView: UIView!    
    @IBOutlet weak var shadeLabel: BaseLabel!
    @IBOutlet weak var tokenView: UIView!
    @IBOutlet weak var balanceView: UIView!
    @IBOutlet weak var refundView: UIView!
    @IBOutlet weak var progressView: UIView!
    
    
    
    var tokenArray: [String] = [] {
        didSet {
            self.tokenView.removeSubviews()
            if tokenArray.count < 6 {
                shadeView.isHidden = true
            } else {
                shadeLabel.text = "+\(tokenArray.count)"
            }
            
            for i in 0..<tokenArray.count {
                let imgView = UIImageView(frame: CGRect(x: 88 - (i+1)*28 + i*13, y: 0, width: 28, height: 28))
//                imgView.kf.setImage(with: URL(string: tokenArray[i]))
                imgView.image = R.image.eosBg()!
                self.tokenView.insertSubview(imgView, at: 0)
            }
            updateHeight()
        }
    }
    
    enum Event:String {
        case CardViewDidClicked
    }
        
    func setup() {
        setupUI()
        setupSubViewEvent()
    }
    
    func setupUI() {
        balanceView.isHidden = true
        refundView.isHidden = true
        progressView.isHidden = true
        updateHeight()
    }
    
    func setupSubViewEvent() {
    
    }
    
    func updateContentSize() {
        updateHeight()
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize.init(width: UIView.noIntrinsicMetric,height: dynamicHeight())
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

