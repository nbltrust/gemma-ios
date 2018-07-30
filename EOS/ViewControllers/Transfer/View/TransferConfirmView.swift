//
//  TransferConfirmView.swift
//  EOS
//
//  Created by 朱宋宇 on 2018/7/12.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import SwiftRichString

@IBDesignable
class TransferConfirmView: UIView {
    @IBOutlet weak var receverView: LineView!
    
    @IBOutlet weak var amountView: LineView!
    
    @IBOutlet weak var remarkView: LineView!
    
    @IBOutlet weak var payAccountView: LineView!
    
    @IBOutlet weak var sureView: Button!
    
    @IBOutlet weak var bottomView: UIView!
    
    enum TransferEvent: String {
        case sureTransfer
    }
    
    func setUp() {
        setupEvent()
        updateHeight()
        receverView.content_style = LineViewStyleNames.transfer_confirm.rawValue
        amountView.content_style = LineViewStyleNames.transfer_confirm.rawValue

        remarkView.content_style = LineViewStyleNames.normal_name.rawValue
        payAccountView.content_style = LineViewStyleNames.transfer_confirm.rawValue
        setRichText()


    }
    
    func setRichText() {
        let money = Style{
            $0.font = SystemFonts.PingFangSC_Semibold.font(size: 16.0)
            $0.color = UIColor.darkSlateBlue
        }
        let eos = Style{
            $0.font = SystemFonts.PingFangSC_Regular.font(size: 12.0)
            
        }
//        let myGroup = StyleGroup(["money": money,"eos" : eos])
//        let text = <money>amountView.content_text</money>  + " EOS"
//        amountView.content_text 
    }
    
    func setupEvent() {
        sureView.button.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] touch in
            guard let `self` = self else { return }
            self.sendEventWith(TransferEvent.sureTransfer.rawValue, userinfo: [ : ])
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    var recever = "" {
        didSet {
            receverView.content_text = recever
        }
    }
    
    var amount = "" {
        didSet {
            amountView.content_text = amount
        }
    }
    
    var remark = "" {
        didSet {
            if remark == "" {
                remark = R.string.localizable.default_remark_pre() + WallketManager.shared.getAccount() + R.string.localizable.default_remark_after()
            }
            remarkView.content_text = remark
        }
    }
    
    var payAccount = "" {
        didSet {
            if payAccount == "" {
                bottomView.isHidden = true
            } else {
                payAccountView.content_text = payAccount
            }
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
