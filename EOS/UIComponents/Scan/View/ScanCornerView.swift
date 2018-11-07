//
//  ScanCornerView.swift
//  EOS
//
//  Created by peng zhu on 2018/7/17.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit

class ScanCornerView: UIView {

    lazy var lineView: UIImageView = {
        let image = R.image.scanning_line()
        let lineView = UIImageView(frame: CGRect(x: 0, y: 5, width: self.width, height: self.width / (image?.size.width)! * (image?.size.height)!))
        lineView.image = image
        lineView.contentMode = .scaleAspectFit
        return lineView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        setupUI()
    }

    func setupUI() {
        self.addSubview(lineView)

        let animation = CABasicAnimation()
        animation.keyPath = "position"
        animation.toValue = NSValue(cgPoint: CGPoint(x: lineView.center.x, y: self.height - lineView.height / 2 - 5))
        animation.duration = 1.5
        animation.autoreverses = true
        animation.repeatCount = HUGE
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards

        lineView.layer.add(animation, forKey: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let magin: CGFloat = 2
        let radius: CGFloat = 8.0

        let path = UIBezierPath(rect: self.bounds)
        path.append(UIBezierPath(roundedRect: CGRect(x: magin, y: magin, width: self.width - 2 * magin, height: self.height - 2 * magin), cornerRadius: radius).reversing())

        let shapLayer = CAShapeLayer()
        shapLayer.frame = self.bounds
        shapLayer.path = path.cgPath
        shapLayer.fillColor = UIColor.whiteColor.cgColor

        self.layer.addSublayer(shapLayer)
    }

}
