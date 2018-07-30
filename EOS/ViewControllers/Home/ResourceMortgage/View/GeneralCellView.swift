//
//  GeneralCellView.swift
//  EOS
//
//  Created by zhusongyu on 2018/7/24.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
@IBDesignable
class GeneralCellView: UIView {
    
    struct GeneralViewModel {
        var name = ""
        var eos = "- EOS"
        var leftSub = ""
        var rightSub = ""
        var lineHidden = false
        var progress: Float = 0.5
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var eosLabel: UILabel!
    @IBOutlet weak var leftSubLabel: UILabel!
    @IBOutlet weak var rightSubLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var pointView: UIView!
    
    var data: GeneralViewModel! {
        didSet {
            nameLabel.text = data.name
            eosLabel.text = data.eos
            leftSubLabel.text = data.leftSub
            rightSubLabel.text = data.rightSub
            lineView.isHidden = data.lineHidden
            progressView.progress = data.progress
            if progressView.progress > 0.7 {
                progressView.tintColor = UIColor.scarlet
                pointView.backgroundColor = UIColor.scarlet
            } else {
                progressView.tintColor = UIColor.darkSkyBlueTwo
                pointView.backgroundColor = UIColor.darkSkyBlueTwo
            }
            updateHeight()
        }
    }
    
    func setUp() {
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
        //        self.insertSubview(view, at: 0)
        
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
