//
//  DashLineView.swift
//  EOS
//
//  Created by 朱宋宇 on 2018/7/6.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation

class DashLineView: UIView {
    override func draw(_ rect: CGRect) {
        let contextRef: CGContext = UIGraphicsGetCurrentContext()!
        contextRef.setStrokeColor(UIColor.separatorColor.cgColor)
        contextRef.beginPath()

        contextRef.move(to: CGPoint(x: 0, y: 0))
        let lengths: [CGFloat] = [5, 7]
        contextRef.setLineDash(phase: 0, lengths: lengths)
        contextRef.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        contextRef.strokePath()
        contextRef.closePath()
    }

}
