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
    
    @IBOutlet weak var sepatateView: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var rightImg: UIImageView!
    
    @IBOutlet weak var imgWidth: NSLayoutConstraint!
    
    @IBInspectable
    var name_style : String = StyleNames.introduce.rawValue {
        didSet{
            self.name.attributedText = name_text.set(style: name_style)
        }
    }
    
    @IBInspectable
    var content_style : String = StyleNames.introduce.rawValue {
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
        }
    }
    
    
    @IBInspectable
    var isShowLine : Bool = false{
        didSet{
            self.sepatateView.isHidden = isShowLine
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
    override func awakeFromNib() {
        super.awakeFromNib()
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
