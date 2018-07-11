//
//  AccountInfo.swift
//  EOS
//
//  Created by 朱宋宇 on 2018/7/6.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation




@IBDesignable

class AccountInfoView: UIView {
    enum lineDirectionType {
        case horType
        case verType
    }
    
    @IBOutlet weak var mTotalEOSLabel: UILabel!
    @IBOutlet weak var mTotalCNYLabel: UILabel!
    @IBOutlet weak var mRemainEOSLabel: UILabel!
    @IBOutlet weak var mRedeemEOSLabel: UILabel!
    @IBOutlet weak var mRemainTimeLabel: UILabel!
    @IBOutlet weak var mCPUConsumeEOSLabel: UILabel!
    @IBOutlet weak var mNETConsumeEOSLabel: UILabel!
    @IBOutlet weak var mRAMConsumeKBLabel: UILabel!
    @IBOutlet weak var mHorLineView: DashLineView!
    @IBOutlet weak var mVerLineView: DashLineView!
    
    var data: Any? {
        didSet {
            
        }
    }
    
    func setUp() {
        
    }
//    var mTotalEOSText = "- EOS" {
//        didSet {
//            mTotalEOSLabel.text = mTotalEOSText
//        }
//    }
//    var mTotalCNYText = "≈- CNY" {
//        didSet {
//            mTotalCNYLabel.text = mTotalCNYText
//        }
//    }
//    var mRemainEOSText = "- EOS" {
//        didSet {
//            mRemainEOSLabel.text = mRemainEOSText
//        }
//    }
//    var mRedeemEOSText = "- EOS" {
//        didSet {
//            mRedeemEOSLabel.text = mRedeemEOSText
//        }
//    }
//    var mRemainTimeText = "" {
//        didSet {
//            mRemainTimeLabel.text = mRemainTimeText
//            if mRemainTimeLabel.text == "" {
//                mRemainTimeLabel.isHidden = true
//            } else {
//                mRemainTimeLabel.isHidden = false
//                mRemainTimeLabel.text = mRemainTimeText
//            }
//        }
//    }
//    var mCPUConsumeEOSText = "CPU\n0.01 EOS" {
//        didSet {
//            mCPUConsumeEOSLabel.text = mCPUConsumeEOSText
//        }
//    }
//    var mNETConsumeEOSText = "NET\n0.01 EOS" {
//        didSet {
//            mNETConsumeEOSLabel.text = mNETConsumeEOSText
//        }
//    }
//    var mRAMConsumeKBText = "RAM\n4.00 KB" {
//        didSet {
//            mRAMConsumeKBLabel.text = mRAMConsumeKBText
//        }
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
