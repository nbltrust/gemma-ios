//
//  ResourceMortgageView.swift
//  EOS
//
//  Created by zhusongyu on 2018/7/24.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation

class ResourceMortgageView: UIView {
    
    @IBOutlet weak var cpuView: GeneralCellView!
    @IBOutlet weak var netView: GeneralCellView!
    @IBOutlet weak var netButton: Button!
    @IBOutlet weak var pageView: PageView!
    @IBOutlet weak var cornerShadowView: CornerAndShadowView!
    
    enum event: String {
        case mortgage
    }
    
    var data: Any? {
        didSet {
            if let data = data as? ResourceViewModel {
                cpuView.data = data.general[0]
                netView.data = data.general[1]
                pageView.data = data.page
                updateHeight()
            }
        }
    }  
    
    func setUp() {
        setupUI()
        setupEvent()
        updateHeight()
    }
    
    func setupEvent() {
        netButton.button.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] touch in
            guard let `self` = self else { return }
            self.sendEventWith(event.mortgage.rawValue, userinfo: ["btntitle" : self.netButton.title])
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
    }
    
    func setupUI() {
        netButton.title = R.string.localizable.mortgage()
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

extension ResourceMortgageView {
    @objc func left(_ data: [String: Any]) {
        netButton.title = R.string.localizable.mortgage()
    }
    @objc func right(_ data: [String: Any]) {
        netButton.title = R.string.localizable.cancel_mortgage()
    }
}
