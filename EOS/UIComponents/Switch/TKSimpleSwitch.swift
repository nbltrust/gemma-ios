//
//  TKSimpleSwitch.swift
//  SwitcherCollection
//
//  Created by Tbxark on 15/10/25.
//  Copyright © 2015年 TBXark. All rights reserved.
//

import UIKit

@IBDesignable
open class TKSimpleSwitch:  TKBaseSwitch {
    
    private var swichControl = CAShapeLayer()
    private var backgroundLayer = CAShapeLayer()
    
    // 是否加旋转特效
    @IBInspectable open var rotateWhenValueChange: Bool = false
    
    @IBInspectable open  var onColor : UIColor = UIColor.red {
        didSet {
            setUpView()
        }
    }
    @IBInspectable open  var offColor : UIColor = UIColor.green {
        didSet {
            setUpView()
        }
    }
    @IBInspectable open  var lineColor : UIColor = UIColor(white: 0.8, alpha: 1) {
        didSet {
            setUpView()
        }
    }
    @IBInspectable open  var circleColor : UIColor = UIColor.white {
        didSet {
            setUpView()
        }
    }
    @IBInspectable open  var lineSize: Double = 10 {
        didSet {
            setUpView()
        }
    }
    
    private var lineWidth : CGFloat {
        return CGFloat(lineSize) * sizeScale
    }
    
    
    // 初始化 View
    override internal func setUpView() {
        super.setUpView()
        self.backgroundColor = UIColor.clear
        let frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        let radius = bounds.height/2 - lineWidth
        let roundedRectPath = UIBezierPath(roundedRect:frame.insetBy(dx: lineWidth, dy: lineWidth) , cornerRadius:radius)
        backgroundLayer.fillColor = stateToFillColor(isOn)
        backgroundLayer.strokeColor = backgroundLayer.fillColor
        backgroundLayer.lineWidth = lineWidth
        backgroundLayer.path = roundedRectPath.cgPath
        layer.addSublayer(backgroundLayer)
        
        let innerLineWidth =  bounds.height - lineWidth*3 + 1
        let swichControlPath = UIBezierPath()
        swichControlPath.move(to: CGPoint(x: lineWidth, y: 0))
        swichControlPath.addLine(to: CGPoint(x: bounds.width - 2 * lineWidth - innerLineWidth + 1, y: 0))
        var point = backgroundLayer.position
        point.y += (radius + lineWidth)
        point.x += (radius)
        swichControl.position = point
        swichControl.path = swichControlPath.cgPath
        swichControl.lineCap     = CAShapeLayerLineCap.round
        swichControl.fillColor   = nil
        swichControl.strokeColor = circleColor.cgColor
        swichControl.lineWidth   = innerLineWidth
        swichControl.strokeEnd = 0.0001
        layer.addSublayer(swichControl)
        
    }

    override public func changeValue() {
        super.changeValue()
        changeValueAnimate(isOn,duration: animateDuration)
    }
    
    
    // MARK: - Animate
    open func changeValueAnimate(_ turnOn:Bool, duration:Double) {
        
        
        let times = [0,0.49,0.51,1]
        
        
        // 线条运动动画
        let swichControlStrokeStartAnim      = CAKeyframeAnimation(keyPath:"strokeStart")
        swichControlStrokeStartAnim.values   = !turnOn ? [1,0,0, 0] : [0,0,0,1]
        swichControlStrokeStartAnim.keyTimes = times as [NSNumber]?
        swichControlStrokeStartAnim.duration = duration
        swichControlStrokeStartAnim.isRemovedOnCompletion = true
        
        let swichControlStrokeEndAnim      = CAKeyframeAnimation(keyPath:"strokeEnd")
        swichControlStrokeEndAnim.values   = !turnOn ? [1,1,1,0] : [0,1,1,1]
        swichControlStrokeEndAnim.keyTimes = times as [NSNumber]?
        swichControlStrokeEndAnim.duration = duration
        swichControlStrokeEndAnim.isRemovedOnCompletion = true
        
        
        
        // 颜色动画
        let backgroundFillColorAnim      = CAKeyframeAnimation(keyPath:"fillColor")
        backgroundFillColorAnim.values   = [stateToFillColor(!turnOn),
                                            stateToFillColor(!turnOn),
                                            stateToFillColor(turnOn),
                                            stateToFillColor(turnOn)]
        backgroundFillColorAnim.keyTimes = [0,0.5,0.51,1]
        backgroundFillColorAnim.duration = duration
        backgroundFillColorAnim.fillMode = CAMediaTimingFillMode.forwards
        backgroundFillColorAnim.isRemovedOnCompletion = false
        
        let backgroundstrokeColorAnim      = CAKeyframeAnimation(keyPath:"strokeColor")
        backgroundstrokeColorAnim.values   = [stateToFillColor(!turnOn),
                                            stateToFillColor(!turnOn),
                                            stateToFillColor(turnOn),
                                            stateToFillColor(turnOn)]
        backgroundstrokeColorAnim.keyTimes = [0,0.5,0.51,1]
        backgroundstrokeColorAnim.duration = duration
        backgroundstrokeColorAnim.fillMode = CAMediaTimingFillMode.forwards
        backgroundstrokeColorAnim.isRemovedOnCompletion = false


        // 旋转动画
        if rotateWhenValueChange{
            UIView.animate(withDuration: duration, animations: { () -> Void in
                self.transform = self.transform.rotated(by: CGFloat.pi)
            })
        }
        
        
        // 动画组
        let swichControlChangeStateAnim : CAAnimationGroup = CAAnimationGroup()
        swichControlChangeStateAnim.animations = [swichControlStrokeStartAnim,swichControlStrokeEndAnim]
        swichControlChangeStateAnim.fillMode = CAMediaTimingFillMode.forwards
        swichControlChangeStateAnim.isRemovedOnCompletion = false
        swichControlChangeStateAnim.duration = duration
        
        let backgroundChangeStateAnim : CAAnimationGroup = CAAnimationGroup()
        backgroundChangeStateAnim.animations = [backgroundFillColorAnim,backgroundstrokeColorAnim]
        backgroundChangeStateAnim.fillMode = CAMediaTimingFillMode.forwards
        backgroundChangeStateAnim.isRemovedOnCompletion = false
        backgroundChangeStateAnim.duration = duration

        let animateKey = turnOn ? "TurnOn" : "TurnOff"
        swichControl.add(swichControlChangeStateAnim, forKey: animateKey)
        backgroundLayer.add(backgroundChangeStateAnim, forKey: "Color")
    }
    
    private func stateToFillColor(_ isOn:Bool) -> CGColor {
        return isOn ?  onColor.cgColor : offColor.cgColor
    }
    
}
