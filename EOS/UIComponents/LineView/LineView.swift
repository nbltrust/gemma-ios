//
//  LineView.swift
//  Demo
//
//  Created by DKM on 2018/7/6.
//  Copyright © 2018年 DKM. All rights reserved.
//

import UIKit


@IBDesignable
class LineView: UIView {

    struct LineViewModel {
        var name : String = ""
        var content : String = ""
        var image_name : String = ""
        var name_style : LineViewStyleNames = .normal_name
        var content_style : LineViewStyleNames = .normal_content
        var isBadge : Bool = false
        var content_line_number : Int = 1
        var isShowLineView : Bool = false
    }
    
    @IBOutlet weak var sepatateView: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var rightImg: UIImageView!
    @IBOutlet weak var imgWidth: NSLayoutConstraint!
    @IBOutlet weak var bgView: UIView!
    
    @IBInspectable
    var name_style : String = LineViewStyleNames.normal_name.rawValue {
        didSet{
            self.name.attributedText = name_text.set(style: name_style)
        }
    }
    
    @IBInspectable
    var content_style : String = LineViewStyleNames.normal_content.rawValue {
        didSet{
            self.content.attributedText = content_text.set(style: content_style)
        }
    }
    
    @IBInspectable
    var name_text : String = ""{
        didSet{
            self.name.attributedText = name_text.set(style: name_style)
        }
    }
    
    @IBInspectable
    var content_text : String = ""{
        didSet{
            self.content.attributedText = content_text.set(style: content_style)
            updateHeight()
        }
    }
    
    
    @IBInspectable
    var isShowLine : Bool = false{
        didSet{
            self.sepatateView.isHidden = !isShowLine
        }
    }
    
    
    @IBInspectable
    var image_name : String = "icCheckCircleGreen" {
        didSet{
            self.rightImg.image = UIImage.init(named: image_name)
            if image_name == " "{
                imgWidth.constant = 0
                layoutIfNeeded()
            }
        }
    }
    
    @IBInspectable
    var content_line_number : Int = 1{
        didSet{
            content.numberOfLines = content_line_number
            if content_line_number >= 1{
                content.lineBreakMode = .byTruncatingTail
            }else{
                content.lineBreakMode = .byCharWrapping
            }
        }
    }
    
    
    var data : Any?{
        didSet{
            if let data = data as? LineViewModel {
                name_text = data.name
                content_text = data.content
                name_style = data.name_style.rawValue
                if data.isBadge{
                    
                }else{
                    content_style = data.content_style.rawValue
                }
                content_line_number = data.content_line_number
                isShowLine = data.isShowLineView
                image_name = data.image_name
            }
        }
    }
    
    func setup(){
        updateHeight()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXIB()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadXIB()
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()
    }
    
    private func updateHeight(){
        layoutIfNeeded()
        self.height = dynamicHeight()
        invalidateIntrinsicContentSize()
    }
    
    override var intrinsicContentSize: CGSize{
        return CGSize(width: UIViewNoIntrinsicMetric, height: dynamicHeight())
    }
    
    fileprivate func dynamicHeight() -> CGFloat{
        let view = self.subviews.last?.subviews.last
        return (view?.frame.origin.y)! + (view?.frame.size.height)!
    }
    
    func loadXIB(){
        let bundle = Bundle(for: type(of: self))
        let nib = UINib.init(nibName: String.init(describing:type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight,.flexibleWidth]
    }
}

