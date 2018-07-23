//
//  BaseView.swift
//  EOS
//
//  Created by peng zhu on 2018/7/22.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit

open class BaseView: UIView {
    open var ltRadius: CGFloat = 0
    open var lbRadius: CGFloat = 0
    open var rtRadius: CGFloat = 0
    open var rbRadius: CGFloat = 0
    
    var _backgroundColor: UIColor? = UIColor.clear
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = _backgroundColor
    }
    
    convenience public init () {
        self.init(frame:CGRect.zero)
    }
    
    convenience public init(frame: CGRect, radius: CGFloat) {
        self.init(frame: frame)
        self.radius = radius
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open var backgroundColor: UIColor? {
        get {
            return _backgroundColor
        }
        set {
            _backgroundColor = newValue
            if self.hasRadius() && newValue != nil && newValue?.isEqual(UIColor.clear) == false {
                // with radius, and color is not clear color, set background color clear color
                super.backgroundColor = UIColor.clear
                self.setNeedsDisplay()
            } else {
                if newValue == nil {
                    super.backgroundColor = UIColor.clear
                }
                else {
                    super.backgroundColor = newValue
                }
            }
        }
    }
    
    func hasRadius() -> Bool {
        return ltRadius > 0 || lbRadius > 0 || rtRadius > 0 || rbRadius > 0
    }
    
    open var radius: CGFloat {
        get {
            if ltRadius == lbRadius && ltRadius == rtRadius && ltRadius == rbRadius {
                // four corner radius are equal
                return ltRadius
            }
            return 0.0;
        }
        set {
            ltRadius = newValue
            lbRadius = newValue
            rtRadius = newValue
            rbRadius = newValue
            
            // Check background color, invoke display
            self.backgroundColor = _backgroundColor
        }
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override open func draw(_ rect: CGRect) {
        
        super.draw(rect)
        
        // Drawing code
        if hasRadius() && self.backgroundColor != nil && self.backgroundColor?.isEqual(UIColor.clear) == false {
            
            // set background clear
            let color:UIColor = self.backgroundColor!
            
            // get the contect
            let context: CGContext = UIGraphicsGetCurrentContext()!
            
            // the rest is pretty much copied from Apples example
            let minx:CGFloat = rect.minX
            let midx:CGFloat = rect.midX
            let maxx:CGFloat = rect.maxX
            let miny:CGFloat = rect.minY
            let midy:CGFloat = rect.midY
            let maxy:CGFloat = rect.maxY
            
            // Start at 1
            context.move(to: CGPoint(x: minx, y: midy))
            // Add an arc through 2 to 3
            context.addArc(tangent1End: CGPoint(x: minx, y: miny), tangent2End: CGPoint(x: midx, y: miny), radius: ltRadius)
            // Add an arc through 4 to 5
            context.addArc(tangent1End: CGPoint(x: maxx, y: miny), tangent2End: CGPoint(x: maxx, y: midy), radius: rtRadius)
            // Add an arc through 6 to 7
            context.addArc(tangent1End: CGPoint(x: maxx, y: maxy), tangent2End: CGPoint(x: midx, y: maxy), radius: rbRadius)
            // Add an arc through 8 to 9
            context.addArc(tangent1End: CGPoint(x: minx, y: maxy), tangent2End: CGPoint(x: minx, y: midy), radius: lbRadius)
            // Close the path
            context.closePath()
            
            //CGContextSetRGBFillColor(context, 1.0, 0.0, 1.0, 1.0);
            context.setFillColor(color.cgColor)
            
            // Fill & stroke the path
            context.drawPath(using: CGPathDrawingMode.fill)
        }
    }
}
