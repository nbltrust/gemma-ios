//
//  HomeTopView.swift
//  EOS
//
//  Created by DKM on 2018/7/11.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit

class HomeTopView: UIView {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var nameRightImgView: UIImageView!
    
    enum event: String {
        case accountlist
    }
    
    var data : Any? {
        didSet{
            if let data = data as? AccountViewModel{
                name.text = data.account
                if data.portrait.count > 0 {
                    let generator = IconGenerator(size: 168, hash: Data(hex: data.portrait))
                    icon.image = UIImage(cgImage: generator.render()!)
                }
            }
        }
    }
    
    func setup(){
        setupEvent()
    }
    
    func setupEvent() {
        nameRightImgView.rx.tapGesture().when(.recognized).subscribe(onNext: {[weak self] tap in
            guard let `self` = self else { return }
            self.nameRightImgView.next?.sendEventWith(event.accountlist.rawValue, userinfo: [:])
        }).disposed(by: disposeBag)

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
