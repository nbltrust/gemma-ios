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
    
    var dirAngle: CGFloat = 0 {
        didSet {
            drawDirection()
        }
    }
    
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
    
    fileprivate func drawArcCenterLayer() {
        let solidCirclePath = UIBezierPath()
        solidCirclePath.addArc(withCenter: CGPoint(x: width / 2, y: width / 2), radius: centerRadio, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: false)
        mainPath.append(solidCirclePath)
        
        path = mainPath.cgPath
    }
    
    fileprivate func drawDirection() {
        self.transformSelf()
        
        let point1 = CGPoint(x:width / 2 + centerRadio + 8 + 6, y: width / 2)
        let point2 = CGPoint(x:width / 2 + centerRadio + 8, y: width / 2 + 5)
        let point3 = CGPoint(x:width / 2 + centerRadio + 8, y: width / 2 - 5)
        let trianglePath = UIBezierPath()
        trianglePath.move(to: point1)
        trianglePath.addLine(to: point2)
        trianglePath.addLine(to: point3)
        trianglePath.close()
        mainPath.append(trianglePath)
        
        path = mainPath.cgPath
    }
    
    fileprivate func transformSelf() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.transform = CATransform3DIdentity
        self.transform = CATransform3DMakeRotation(dirAngle, 0, 0, 1)
        CATransaction.commit()
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
        drawArcCenterLayer()
    }
    
    fileprivate func trunWarning() {
        borderColor = GestureLockSetting.warningColor.cgColor
        borderWidth = GestureLockSetting.lockHighlightedBorderWidth
        fillColor = GestureLockSetting.warningColor.cgColor
    }
}
