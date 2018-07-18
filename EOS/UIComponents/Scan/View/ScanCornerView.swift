//
//  ScanCornerView.swift
//  EOS
//
//  Created by peng zhu on 2018/7/17.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit

class ScanCornerView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
//        let magin: CGFloat = 2
//        let radius: CGFloat = 8.0
//        
//        let path: CGMutablePath = CGMutablePath()
//        
//        path.move(to: CGPoint(x: magin + radius, y: magin))
//        path.addLine(to: CGPoint(x: self.width - magin - radius, y: magin))
//        path.addArc(center: CGPoint(x: self.width - magin - radius, y: magin + radius), radius: radius, startAngle: 0, endAngle: CGFloat(Double.pi / 2), clockwise: true)
//        
//        path.addLine(to: CGPoint(x: self.width - magin - radius, y: self.height - magin))
//        path.addArc(center: CGPoint(x: self.width - magin - radius, y: self.height - magin - radius), radius: radius, startAngle: CGFloat(Double.pi / 2), endAngle: CGFloat(Double.pi), clockwise: true)
//        
//        path.addLine(to: CGPoint(x: magin + radius, y: self.height - magin))
//        path.addArc(center: CGPoint(x: magin + radius, y: self.height - magin - radius), radius: radius, startAngle: CGFloat(Double.pi), endAngle: CGFloat(Double.pi * 3 / 2), clockwise: true)
//        
//        path.addLine(to: CGPoint(x: magin, y: magin + radius))
//        path.addArc(center: CGPoint(x: magin + radius, y: magin + radius), radius: radius, startAngle: CGFloat(Double.pi * 3 / 2), endAngle: CGFloat(Double.pi * 2), clockwise: true)
//        
//        let shapLayer = CAShapeLayer()
//        shapLayer.frame = self.bounds
//        shapLayer.path = path
//        
//        self.layer.mask = shapLayer
    }

}
