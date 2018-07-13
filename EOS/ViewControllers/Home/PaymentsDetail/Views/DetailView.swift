//
//  DetailView.swift
//  EOS
//
//  Created by DKM on 2018/7/12.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift


class DetailView: UIView {
    enum event_name : String {
        case open_safair
    }
    
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var state: UILabel!
    @IBOutlet weak var memo: UILabel!
    @IBOutlet weak var tradeNumber: UILabel!
    @IBOutlet weak var blcok: UILabel!
    @IBOutlet weak var stateIcon: UIImageView!
    @IBOutlet weak var money: UILabel!
    
    @IBOutlet weak var webLabel: UILabel!
    var data : Any? {
        didSet{
            if let data = data as? PaymentsRecordsViewModel {
                
                address.text = data.address
                time.text = data.time
                state.text = data.transferState
                memo.text = data.memo
                tradeNumber.text = data.hashNumber
                blcok.text = "\(data.block)"
                stateIcon.image = data.stateImageName ==  R.image.icIncome() ? R.image.icIncomeWhite() : R.image.ic_income_white()
                money.text = data.money
            }
        }
    }
    
    
    func setup(){
        updateHeight()
        self.webLabel.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(openSafair))
        
        self.webLabel.addGestureRecognizer(tap)
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
extension DetailView {
    @objc func openSafair(){
        self.next?.sendEventWith(event_name.open_safair.rawValue, userinfo: [:])
    }
}
