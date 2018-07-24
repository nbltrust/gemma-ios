//
//  GestureItemLayer.swift
//  EOS
//
//  Created by peng zhu on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit

enum GestureLockItemStatus: Int {
    case normal = 1
    case highlighted
    case warning
}

class GestureItemLayer: CAShapeLayer {
    var status: GestureLockItemStatus = .normal {
        didSet {
            setupStatus()
        }
    }
    
    var width: CGFloat = 0 {
        didSet {
            frame.size = CGSize(width: width, height: width)
            self.cornerRadius = width / 2
        }
    }
    
    var index: Int = 0
    
    var centerRadio: CGFloat = 0
    
    var origin: CGPoint = CGPoint.zero {
        didSet {
            frame.origin = origin
        }
    }
    
    var dirAngle: Double = 0
    
    private let mainPath = UIBezierPath()
    
    private let dirLayer = CAShapeLayer()
    
    override init() {
        super.init()
        setupStatus()
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
        setupStatus()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(layer: aDecoder)
        setupStatus()
    }
    
    func reset() {
        status = .normal
    }
    
    func setupStatus() {
        if status == .normal {
            self.turnNormal()
        } else if status == .highlighted {
            self.turnHighlighted()
        } else {
            self.trunWarning()
        }
    }
    
    fileprivate func triangleCenterGap() -> CGFloat {
        return centerRadio + 5 + 3
    }
    
    fileprivate func drawCenterCircle() {
        let solidCirclePath = UIBezierPath()
        solidCirclePath.addArc(withCenter: CGPoint(x: width / 2, y: width / 2), radius: centerRadio, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: false)
        mainPath.append(solidCirclePath)
        path = mainPath.cgPath
    }
    
    fileprivate func drawDirection() {
        
    }
    
    fileprivate func removePaths() {
        mainPath.removeAllPoints()
        path = mainPath.cgPath
    }
    
    fileprivate func turnNormal() {
        borderColor = GestureLockSetting.lockNormalColor.cgColor
        borderWidth = GestureLockSetting.lockNormalBoderWidth
        backgroundColor = UIColor.clear.cgColor
        fillColor = GestureLockSetting.lockHighlightedColor.cgColor
        removePaths()
    }
    
    fileprivate func turnHighlighted() {
        borderColor = GestureLockSetting.lockHighlightedColor.cgColor
        borderWidth = GestureLockSetting.lockHighlightedBorderWidth
        drawCenterCircle()
    }
    
    fileprivate func trunWarning() {
        borderColor = GestureLockSetting.warningColor.cgColor
        borderWidth = GestureLockSetting.lockHighlightedBorderWidth
        fillColor = GestureLockSetting.warningColor.cgColor
    }
}
