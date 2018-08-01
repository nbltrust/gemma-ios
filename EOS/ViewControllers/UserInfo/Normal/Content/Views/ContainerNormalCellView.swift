//
//  ContainerNormalCellView.swift
//  EOS
//
//  Created by DKM on 2018/8/1.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import TinyConstraints

class ContainerNormalCellView: UIView {

    enum event : String {
        case selectedSetting
    }
    
    @IBOutlet weak var stackView: UIStackView!
    
    var selectedIndex : Int = 0
    var data : Any? {
        didSet{
            if let data = data as? [String] {
                self.removeStackViewSubviews()
                for index in 0..<data.count {
                    let item = data[index]
                    let cellView = NormalCellView(frame: CGRect(x: 0, y: 0, width: self.stackView.width, height: 48))
                    cellView.index = index
                    cellView.name_text = item
                    cellView.state = 1
                    cellView.backgroundColor = UIColor.whiteTwo89
                    cellView.name_style = LineViewStyleNames.normal_name.rawValue
                    cellView.rightIconName = index == self.selectedIndex ? R.image.group.name : R.image.select.name
                    if index == data.count - 1{
                        cellView.isShowLineView = true
                    }
                    self.stackView.addArrangedSubview(cellView)
                    cellView.height(48)
                    
                }
                self.layoutIfNeeded()
                updateHeight()
            }
        }
    }
    
    fileprivate func removeStackViewSubviews() {
        for subView in self.stackView.arrangedSubviews {
            subView.removeFromSuperview()
        }
        updateHeight()
    }
    
    
    func setup() {

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
        setup()
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
extension ContainerNormalCellView {
    @objc func clickCellView(_ sender : [String:Any]) {
        if let index = sender["index"] as? Int {
            for subView in self.stackView.arrangedSubviews {
                if let view = subView as? NormalCellView {
                    if view.index == index {
                        view.rightIconName = R.image.group.name
                    }
                    else {
                        view.rightIconName = R.image.select.name
                    }
                }
            }
        }
        self.sendEventWith(event.selectedSetting.rawValue, userinfo: ["index":index])
    }
}
